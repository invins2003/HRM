// OptimizedFaceProcessingScreen.dart
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

// Your existing imports
import 'package:erp_admin/module/DashBoard/Controller/EmployeeListController.dart';
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// FaceNetService (unchanged)
class FaceNetService {
  Interpreter? _interpreter;
  Future<void> loadModel() async {
    try {
      final options = InterpreterOptions();
      if (Platform.isAndroid) options.addDelegate(XNNPackDelegate());
      _interpreter = await Interpreter.fromAsset(
        'assets/model/mobilefacenet.tflite',
        options: options,
      );
      debugPrint("FaceNet model loaded ✅");
    } catch (e) {
      debugPrint("Error loading FaceNet model: $e");
    }
  }

  List<double>? getEmbedding(img.Image faceImage) {
    if (_interpreter == null) return null;

    final resized = img.copyResize(faceImage, width: 112, height: 112);
    final input = Float32List(1 * 112 * 112 * 3);
    int index = 0;

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        final pixel = resized.getPixel(x, y);
        input[index++] = (pixel.r - 127.5) / 128.0;
        input[index++] = (pixel.g - 127.5) / 128.0;
        input[index++] = (pixel.b - 127.5) / 128.0;
      }
    }

    final reshaped = input.reshape([1, 112, 112, 3]);
    final output = List.filled(192, 0.0).reshape([1, 192]);
    _interpreter!.run(reshaped, output);
    return List<double>.from(output[0]);
  }

  void dispose() => _interpreter?.close();
}

/// Optimized FaceProcessingScreen
class FaceProcessingScreen extends StatefulWidget {
  final int maxCaptures;
  final CameraDescription camera;
  final List<Data>? allEmployees;
  final DashBoardEmployeeList? controller;

  const FaceProcessingScreen({
    super.key,
    required this.camera,
    this.maxCaptures = 1,
    this.allEmployees,
    this.controller,
  });

  @override
  State<FaceProcessingScreen> createState() => _FaceProcessingScreenState();
}

class _FaceProcessingScreenState extends State<FaceProcessingScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  final FaceNetService _facenet = FaceNetService();

  // Registration captures
  final List<List<double>> _capturedEmbeddings = [];

  List<Data>? _currentEmployees;

  bool _loading = true;
  String _message = "Initializing...";

  CameraDescription? _currentCamera;
  List<CameraDescription>? _availableCameras;

  bool _isProcessingStream = false;
  bool _isCapturing = false;
  bool _isAttendanceMode = false;

  // --- 💡 NEW: Safety Lock to prevent loops ---
  bool _isRestarting = false;
  int _restartAttempts = 0; 

  // --- Tuning constants
  final int _frameIntervalMs = 600;
  final double _matchingThreshold = 0.70;
  final int _employeeRefreshHours = 1;

  // --- 💡 REPLACED: Removed blind restart timer, added Watchdog ---
  final int _watchdogIntervalSeconds = 30; // Check health every 30s
  final int _maxFrameDelaySeconds = 10; // If no frame for 10s (and active), restart.

  final int _detectorRestartHours = 6;

  // Timers
  Timer? _watchdogTimer; // 💡 NEW: Replaces camera restart timer
  Timer? _detectorRestartTimer;
  Timer? _employeeRefreshTimer;

  DateTime _lastFrameProcessed = DateTime.now(); // Initialize to now

  // Failure backoff
  int _consecutiveErrors = 0;
  final int _maxConsecutiveErrorsBeforeRestart = 5;

  // --- Sleep/Wake State Variables ---
  bool _isDormant = false;
  DateTime _lastFaceDetectedTime = DateTime.now();
  final int _dormantFrameIntervalMs = 5000;
  final int _activityTimeoutMinutes = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentCamera = widget.camera;

    _currentEmployees = widget.allEmployees;
    _isAttendanceMode = _currentEmployees != null && widget.controller != null;

    _message = _isAttendanceMode
        ? "Show your face to capture"
        : "Show your face and tap capture (0/${widget.maxCaptures})";

    _lastFaceDetectedTime = DateTime.now();

    _initializeAll();
  }

  Future<void> _initializeAll() async {
    setState(() => _loading = true);

    try {
      await _facenet.loadModel();

      try {
        await WakelockPlus.enable();
      } catch (e) {
        debugPrint("Wakelock enable failed: $e");
      }

      _availableCameras = await availableCameras();

      if (_currentCamera == null) {
        debugPrint("No camera provided.");
        setState(() => _loading = false);
        return;
      }

      await _initFaceDetector();
      await _initCameraController();

      _startPeriodicTasks();
    } catch (e, st) {
      debugPrint("Initialization error: $e\n$st");
      setState(() => _message = "Initialization error");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Face _getClosestFace(List<Face> faces) {
    faces.sort((a, b) {
      final areaA = a.boundingBox.width * a.boundingBox.height;
      final areaB = b.boundingBox.width * b.boundingBox.height;
      return areaB.compareTo(areaA);
    });
    return faces.first;
  }

  Future<void> _initFaceDetector() async {
    try {
      _faceDetector?.close();
    } catch (_) {}
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    debugPrint("FaceDetector initialized");
  }

  Future<void> _initCameraController() async {
    // 💡 Lock restarts during init
    if (_isRestarting && _restartAttempts == 0) return;

    try {
      await _cameraController?.stopImageStream();
    } catch (_) {}
    try {
      await _cameraController?.dispose();
    } catch (_) {}

    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();

    // Reset frame timer on successful init
    _lastFrameProcessed = DateTime.now();

    if (_isAttendanceMode) {
      await _cameraController!.startImageStream(_onImageStream);
    }

    debugPrint("Camera initialized: ${_currentCamera!.name}");
  }

  void _startPeriodicTasks() {
    _watchdogTimer?.cancel(); // 💡 Cancel old
    _detectorRestartTimer?.cancel();
    _employeeRefreshTimer?.cancel();

    // 💡 NEW: Watchdog Timer
    _watchdogTimer = Timer.periodic(Duration(seconds: _watchdogIntervalSeconds), (
      _,
    ) async {
      if (_isRestarting || !_isAttendanceMode) return;

      final secondsSinceLastFrame = DateTime.now()
          .difference(_lastFrameProcessed)
          .inSeconds;

      // If we are NOT dormant, but haven't seen a frame in 10+ seconds, the camera is likely dead.
      if (!_isDormant && secondsSinceLastFrame > _maxFrameDelaySeconds) {
        debugPrint(
          "🚨 Watchdog: No frames for $secondsSinceLastFrame s. Restarting Camera...",
        );
        await _safeCameraRestart();
      }
    });

    // Detector restart is fine (pure software, no hardware driver issues)
    _detectorRestartTimer = Timer.periodic(
      Duration(hours: _detectorRestartHours),
      (_) async {
        debugPrint("Periodic detector restart triggered");
        await _safeDetectorRestart();
      },
    );

    if (_isAttendanceMode) {
      _employeeRefreshTimer = Timer.periodic(
        Duration(hours: _employeeRefreshHours),
        (_) {
          debugPrint("Periodic employee refresh triggered");
          _refreshEmployeeData();
        },
      );
    }
  }

  Future<void> _refreshEmployeeData() async {
    if (widget.controller == null || !mounted || !_isAttendanceMode) return;
    try {
      await widget.controller!.listtController();
      final newList = widget.controller!.employeelisttt
          .where(
            (e) =>
                e.isActive == true &&
                e.biometricEmpId != null &&
                e.biometricEmpId!.isNotEmpty,
          )
          .toList();
      if (mounted) {
        setState(() {
          _currentEmployees = newList;
        });
        debugPrint("✅ Employee list refreshed.");
      }
    } catch (e) {
      debugPrint("Error refreshing employee list: $e");
    }
  }


Future<void> _safeCameraRestart() async {
  if (!mounted || _isRestarting) return;
  _isRestarting = true;
  _restartAttempts++;

  if (mounted) setState(() => _message = "System Refreshing... (Attempt $_restartAttempts)");

  try {
    // 1. Force stop and nullify
    await _cameraController?.stopImageStream().catchError((e) => debugPrint(e.toString()));
    await _cameraController?.dispose();
    _cameraController = null; 
    
    // 2. Longer hardware cooling period
    await Future.delayed(const Duration(seconds: 3));

    // 3. Re-init
    await _initCameraController();
    
    _restartAttempts = 0; // Reset counter on success
    _consecutiveErrors = 0;
  } catch (e) {
    debugPrint("Restart Attempt $_restartAttempts failed: $e");
    
    // 4. THE NUCLEAR OPTION: If 2 soft restarts fail, trigger Phoenix
    if (_restartAttempts >= 2) {
       _triggerAppRelaunch();
    }
  } finally {
    _isRestarting = false;
  }
}

Future<void> _triggerAppRelaunch() async {
  // 1. Save that we were on the camera page
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('should_auto_resume_camera', true);

  // 2. Relaunch the entire Flutter engine
  Phoenix.rebirth(context);
}

  Future<void> _safeDetectorRestart() async {
    if (!mounted) return;
    try {
      await _faceDetector?.close();
    } catch (e) {
      debugPrint("Error closing detector: $e");
    }
    await Future.delayed(const Duration(milliseconds: 400));
    await _initFaceDetector();
    debugPrint("Detector restarted");
  }

  Future<void> _recreateAll() async {
    if (_isRestarting) return;
    _isRestarting = true;

    debugPrint("Recreating everything due to repeated errors.");
    try {
      await _cameraController?.stopImageStream();
    } catch (_) {}
    try {
      await _cameraController?.dispose();
    } catch (_) {}
    try {
      await _faceDetector?.close();
    } catch (_) {}

    await Future.delayed(const Duration(seconds: 2));

    _isRestarting = false; // Unlock before init
    await _initFaceDetector();
    await _initCameraController();
  }

  Future<void> _onImageStream(CameraImage image) async {
    // --- 💡 CRITICAL FIX: Abort if restarting or disposed ---
    if (_isRestarting || _isProcessingStream || _isCapturing) return;
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    final now = DateTime.now();
    final int currentInterval = _isDormant
        ? _dormantFrameIntervalMs
        : _frameIntervalMs;

    if (now.difference(_lastFrameProcessed).inMilliseconds < currentInterval) {
      return;
    }
    _lastFrameProcessed = now; // 💡 WATCHDOG SYNC: Update timestamp on every frame

    _isProcessingStream = true;
    try {
      if (_cameraController == null) return;

      final inputImage = _createInputImageFromCameraImage(image);
      if (inputImage == null) return;

      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isNotEmpty && mounted) {
        _lastFaceDetectedTime = DateTime.now();

        if (_isDormant) {
          setState(() => _isDormant = false);
        }

        if (!_isCapturing) {
          setState(() => _message = "✅ Face detected! Verifying...");
          await _captureAndMatchFace();
        }
      } else if (mounted && !_isCapturing) {
        if (_isDormant) {
          if (mounted)
            setState(() => _message = "Sleeping... (no face detected)");
        } else {
          if (DateTime.now().difference(_lastFaceDetectedTime).inMinutes >=
              _activityTimeoutMinutes) {
            debugPrint("Entering dormant state due to inactivity.");
            if (mounted) {
              setState(() {
                _isDormant = true;
                _message = "Sleeping... (no face detected)";
              });
            }
          } else {
            if (mounted) setState(() => _message = "Show your face to capture");
          }
        }
      }
    } catch (e) {
      debugPrint("Stream processing error: $e");
    } finally {
      _isProcessingStream = false;
    }
  }

  InputImage? _createInputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    final format = Platform.isAndroid
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;

    if (image.format.group !=
        (Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888)) {
      return null;
    }

    final allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final rotation = _getInputImageRotation();
    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  InputImageRotation _getInputImageRotation() {
    if (_currentCamera == null) return InputImageRotation.rotation0deg;
    final sensorOrientation = _currentCamera!.sensorOrientation;
    switch (sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<void> _captureAndMatchFace() async {
    if (_isCapturing || _cameraController == null || !mounted || _isRestarting)
      return;
    setState(() => _isCapturing = true);

    try {
      final cameraImage = await _cameraController!.takePicture();
      final file = File(cameraImage.path);
      final imageBytes = await file.readAsBytes();

      final inputImage = InputImage.fromFilePath(cameraImage.path);
      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = _getClosestFace(faces);
        final decodedImage = img.decodeImage(imageBytes)!;
        final rect = face.boundingBox;

        final left = rect.left.toInt().clamp(0, decodedImage.width - 1);
        final top = rect.top.toInt().clamp(0, decodedImage.height - 1);
        final width = rect.width.toInt().clamp(1, decodedImage.width - left);
        final height = rect.height.toInt().clamp(1, decodedImage.height - top);

        final faceCrop = img.copyCrop(
          decodedImage,
          x: left,
          y: top,
          width: width,
          height: height,
        );
        final embedding = _facenet.getEmbedding(faceCrop);

        if (embedding != null && _currentEmployees != null) {
          Data? matchedEmployee;
          double bestScore = -1.0;

          for (final emp in _currentEmployees!) {
            final storedEmbeddings = emp.biometricEmpId!
                .map<List<double>>(
                  (e) => (e as List).map<double>((v) => v.toDouble()).toList(),
                )
                .toList();

            for (var s in storedEmbeddings) {
              final sim = _cosineSimilarity(embedding, s);
              if (sim > bestScore) {
                bestScore = sim;
                matchedEmployee = emp;
              }
            }
          }

          if (matchedEmployee != null && bestScore >= _matchingThreshold) {
            if (mounted) {
              setState(() => _message = "✅ ${matchedEmployee?.name} Verified!");
            }

            try {
              widget.controller?.verifyAttendance(
                embedding,
                matchedEmployee.employeeId.toString(),
              );
            } catch (e) {
              debugPrint("Controller verifyAttendance error: $e");
            }
            await Future.delayed(const Duration(seconds: 3));
          } else {
            if (mounted)
              setState(() => _message = "⚠️ No Match Found. Try again.");
            await Future.delayed(const Duration(seconds: 2));
          }
        } else {
          if (mounted)
            setState(() => _message = "⚠️ No face detected or model error.");
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }  else {
        if (mounted)
          setState(() => _message = "⚠️ No face detected. Try again!");
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      debugPrint("Error capturing face: $e");
      if (mounted) setState(() => _message = "Error capturing face.");
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      if (mounted) {
        setState(() {
          _message = _isDormant
              ? "Sleeping... (no face detected)"
              : "Show your face to capture";
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _captureForRegistration() async {
    // Check restarting flag
    if (_isCapturing || _cameraController == null || !mounted || _isRestarting)
      return;
    setState(() => _isCapturing = true);

    try {
      final cameraImage = await _cameraController!.takePicture();
      final file = File(cameraImage.path);
      final imageBytes = await file.readAsBytes();

      final inputImage = InputImage.fromFilePath(cameraImage.path);
      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = _getClosestFace(faces);

        final decodedImage = img.decodeImage(imageBytes)!;
        final rect = face.boundingBox;
        final left = rect.left.toInt().clamp(0, decodedImage.width - 1);
        final top = rect.top.toInt().clamp(0, decodedImage.height - 1);
        final width = rect.width.toInt().clamp(1, decodedImage.width - left);
        final height = rect.height.toInt().clamp(1, decodedImage.height - top);

        final faceCrop = img.copyCrop(
          decodedImage,
          x: left,
          y: top,
          width: width,
          height: height,
        );
        final embedding = _facenet.getEmbedding(faceCrop);

        if (embedding != null) {
          _capturedEmbeddings.add(embedding);
          final remaining = widget.maxCaptures - _capturedEmbeddings.length;

          if (remaining > 0) {
            if (mounted) {
              setState(
                () => _message =
                    "✅ Captured face (${_capturedEmbeddings.length}/${widget.maxCaptures})",
              );
            }
          } else {
            if (mounted) {
              setState(
                () => _message = "✅ All ${widget.maxCaptures} faces captured!",
              );
            }
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) Navigator.pop(context, _capturedEmbeddings);
          }
        } else {
          if (mounted)
            setState(() => _message = "Error generating embedding. Try again.");
        }
      }  else {
        if (mounted)
          setState(() => _message = "⚠️ No face detected. Try again!");
      }
    } catch (e) {
      debugPrint("Registration capture error: $e");
      if (mounted) setState(() => _message = "Error. Try again.");
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return -1.0;
    double dot = 0.0, normA = 0.0, normB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    final denom = sqrt(normA) * sqrt(normB);
    return denom == 0 ? -1.0 : dot / denom;
  }

  Future<void> _switchCamera() async {
    if (_availableCameras == null || _availableCameras!.length < 2) return;
    if (_isRestarting) return; // Prevent switch during restart

    try {
      if (_isAttendanceMode) await _cameraController?.stopImageStream();
      await _cameraController?.dispose();
    } catch (e) {
      debugPrint("Switch camera cleanup error: $e");
    }

    _currentCamera = _availableCameras!.firstWhere(
      (cam) => cam.lensDirection != _currentCamera!.lensDirection,
      orElse: () => _availableCameras!.first,
    );

    await _initCameraController();
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!mounted) return;
    // Don't interfere if we are in the middle of a controlled restart
    if (_isRestarting) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      try {
        await _cameraController?.stopImageStream();
        await _cameraController?.dispose();
      } catch (e) {
        debugPrint("Lifecycle pause stop error: $e");
      }
    } else if (state == AppLifecycleState.resumed) {
      await Future.delayed(const Duration(milliseconds: 300));
      await _initFaceDetector();
      await _initCameraController();
      _lastFaceDetectedTime = DateTime.now();
      _lastFrameProcessed = DateTime.now(); // Reset watchdog
      if (mounted) setState(() => _isDormant = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // Cancel all timers
    _watchdogTimer?.cancel();
    _detectorRestartTimer?.cancel();
    _employeeRefreshTimer?.cancel();

    try {
      _cameraController?.stopImageStream();
    } catch (_) {}
    try {
      _cameraController?.dispose();
    } catch (_) {}
    try {
      _faceDetector?.close();
    } catch (_) {}
    _facenet.dispose();

    try {
      WakelockPlus.disable();
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      // 💡 RECOVERY UI: Show a clean spinner during restarts
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.green),
              const SizedBox(height: 20),
              Text(
                _isRestarting ? "Refreshing Camera System..." : "Starting...",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _message.contains("Too many faces")
                    ? Colors.red.withOpacity(0.8)
                    : _isDormant
                    ? Colors.blueGrey.withOpacity(0.8)
                    : Colors.green.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: FloatingActionButton(
              heroTag: "switchCamera",
              onPressed: _switchCamera,
              backgroundColor: Colors.green,
              child: const Icon(Icons.cameraswitch, color: Colors.white),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: FloatingActionButton(
              heroTag: "backButton",
              onPressed: () => Navigator.pop(context),
              backgroundColor: Colors.black.withOpacity(0.5),
              mini: true,
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButton: _isAttendanceMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _captureForRegistration,
              label: const Text(
                "Capture Face",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              backgroundColor: Colors.green,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}