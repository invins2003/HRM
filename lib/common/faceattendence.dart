// OptimizedFaceProcessingScreen.dart
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

// Your existing imports for controller & model
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
  final int maxCaptures; // For registration (e.g., 3)
  final CameraDescription camera;
  final List<Data>? allEmployees; // OPTIONAL: For attendance mode
  final DashBoardEmployeeList? controller; // OPTIONAL: For attendance mode

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

  bool _loading = true;
  String _message = "Initializing...";

  CameraDescription? _currentCamera;
  List<CameraDescription>? _availableCameras;

  bool _isProcessingStream = false;
  bool _isCapturing = false;
  bool _isAttendanceMode = false;

  // --- Tuning constants (adjust to device)
  final int _frameIntervalMs = 600; // process ~1.66 frames/sec
  final int _cameraRestartHours = 2; // restart camera every 2 hours
  final int _detectorRestartHours = 6; // recreate detector every 6 hours
  final double _matchingThreshold = 0.60; // cosine similarity threshold

  // Timers and state
  Timer? _cameraRestartTimer;
  Timer? _detectorRestartTimer;
  DateTime _lastFrameProcessed = DateTime.fromMillisecondsSinceEpoch(0);

  // Failure backoff
  int _consecutiveErrors = 0;
  final int _maxConsecutiveErrorsBeforeRestart = 5;

  // --- 💡 NEW: Sleep/Wake State Variables ---
  bool _isDormant = false;
  DateTime _lastFaceDetectedTime = DateTime.now();
  final int _dormantFrameIntervalMs = 5000; // 5 seconds (when dormant)
  final int _activityTimeoutMinutes = 5; // 5 minutes (to enter dormant)
  // --- End New Variables ---

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentCamera = widget.camera;
    _isAttendanceMode = widget.allEmployees != null && widget.controller != null;

    _message = _isAttendanceMode
        ? "Show your face to capture"
        : "Show your face and tap capture (0/${widget.maxCaptures})";
    
    // Initialize last detected time
    _lastFaceDetectedTime = DateTime.now();

    _initializeAll();
  }

  Future<void> _initializeAll() async {
    setState(() => _loading = true);

    try {
      // Load model
      await _facenet.loadModel();

      // Prevent screen sleep
      try {
        await WakelockPlus.enable();
      } catch (e) {
        debugPrint("Wakelock enable failed: $e");
      }

      // Init camera list
      _availableCameras = await availableCameras();

      if (_currentCamera == null) {
        debugPrint("No camera provided.");
        setState(() => _loading = false);
        return;
      }

      // Init detector and camera
      await _initFaceDetector();
      await _initCameraController();

      // Start timers for periodic restarts
      _startPeriodicTasks();
    } catch (e, st) {
      debugPrint("Initialization error: $e\n$st");
      setState(() => _message = "Initialization error");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
    // Dispose old controller if present
    try {
      await _cameraController?.stopImageStream();
    } catch (_) {}
    try {
      await _cameraController?.dispose();
    } catch (_) {}

    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.medium, // low for continuous stream
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();

    // Start stream only in attendance mode
    if (_isAttendanceMode) {
      await _cameraController!.startImageStream(_onImageStream);
    }

    debugPrint("Camera initialized: ${_currentCamera!.name}");
  }

  void _startPeriodicTasks() {
    _cameraRestartTimer?.cancel();
    _detectorRestartTimer?.cancel();

    _cameraRestartTimer =
        Timer.periodic(Duration(hours: _cameraRestartHours), (_) async {
      debugPrint("Periodic camera restart triggered");
      await _safeCameraRestart();
    });

    _detectorRestartTimer =
        Timer.periodic(Duration(hours: _detectorRestartHours), (_) async {
      debugPrint("Periodic detector restart triggered");
      await _safeDetectorRestart();
    });
  }

  Future<void> _safeCameraRestart() async {
    if (!mounted) return;
    try {
      if (_isAttendanceMode) {
        await _cameraController?.stopImageStream();
      }
      await _cameraController?.dispose();
    } catch (e) {
      debugPrint("Error stopping camera before restart: $e");
    }

    // small pause
    await Future.delayed(const Duration(milliseconds: 800));

    // Re-create controller
    try {
      await _initCameraController();
      _consecutiveErrors = 0; // reset
      if (mounted) setState(() => _message = "Camera restarted");
    } catch (e) {
      debugPrint("Camera restart failed: $e");
      _consecutiveErrors++;
      if (_consecutiveErrors >= _maxConsecutiveErrorsBeforeRestart) {
        // escalate: recreate everything
        await _recreateAll();
      }
    }
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
    debugPrint("Recreating camera & detector due to repeated errors.");
    try {
      await _cameraController?.stopImageStream();
    } catch (_) {}
    try {
      await _cameraController?.dispose();
    } catch (_) {}
    try {
      await _faceDetector?.close();
    } catch (_) {}
    await Future.delayed(const Duration(seconds: 1));
    await _initFaceDetector();
    await _initCameraController();
  }

  // --- 💡 UPDATED: Image stream handler (attendance only) ---
  Future<void> _onImageStream(CameraImage image) async {
    if (_isProcessingStream || _isCapturing) return;

    // --- NEW: DYNAMIC THROTTLE ---
    final now = DateTime.now();
    // Use dormant interval if sleeping, otherwise use normal interval
    final int currentInterval =
        _isDormant ? _dormantFrameIntervalMs : _frameIntervalMs;

    if (now.difference(_lastFrameProcessed).inMilliseconds < currentInterval) {
      return; // Throttled
    }
    _lastFrameProcessed = now;
    // --- END NEW: DYNAMIC THROTTLE ---

    _isProcessingStream = true;
    try {
      if (_cameraController == null || _faceDetector == null) return;

      final inputImage = _createInputImageFromCameraImage(image);
      if (inputImage == null) {
        return;
      }

      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isNotEmpty && mounted) {
        // --- FACE DETECTED ---
        _lastFaceDetectedTime = DateTime.now(); // Update activity timer

        if (_isDormant) {
          // --- WAKE UP ---
          debugPrint("Waking up from dormant state!");
          if (mounted) setState(() => _isDormant = false);
        }

        // Proceed with capture ONLY if not already capturing
        if (!_isCapturing) {
          if (mounted) setState(() => _message = "✅ Face detected! Verifying...");
          await _captureAndMatchFace();
        }
      } else if (mounted && !_isCapturing) {
        // --- NO FACE DETECTED ---
        if (_isDormant) {
          // Already dormant, just ensure message is correct
          if (mounted) setState(() => _message = "Sleeping... (no face detected)");
        } else {
          // --- CHECK IF WE SHOULD GO TO SLEEP ---
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
            // Not dormant, and not time to sleep yet
            if (mounted) setState(() => _message = "Show your face to capture");
          }
        }
      }
    } catch (e) {
      debugPrint("Stream processing error: $e");
      _consecutiveErrors++;
      if (_consecutiveErrors >= _maxConsecutiveErrorsBeforeRestart) {
        await _recreateAll();
        _consecutiveErrors = 0;
      }
    } finally {
      _isProcessingStream = false;
    }
  }
  // --- End Updated Method ---

  InputImage? _createInputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    final format = Platform.isAndroid
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;

    if (image.format.group !=
        (Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888)) {
      debugPrint("Unexpected image format ${image.format.group}");
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
    final camera = _currentCamera!;
    final sensorOrientation = camera.sensorOrientation;
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

  // --- Attendance capture + match (high-res photo capture) ---
Future<void> _captureAndMatchFace() async {
  if (_isCapturing || _cameraController == null || !mounted) return;
  setState(() => _isCapturing = true);

  try {
    final cameraImage = await _cameraController!.takePicture();
    final file = File(cameraImage.path);
    final imageBytes = await file.readAsBytes();

    final inputImage = InputImage.fromFilePath(cameraImage.path);
    final faces = await _faceDetector!.processImage(inputImage);

    if (faces.isNotEmpty) {
      final face = faces.first;
      final decodedImage = img.decodeImage(imageBytes)!;
      final rect = face.boundingBox;

      final left = rect.left.toInt().clamp(0, decodedImage.width - 1);
      final top = rect.top.toInt().clamp(0, decodedImage.height - 1);
      final width = rect.width.toInt().clamp(1, decodedImage.width - left);
      final height = rect.height.toInt().clamp(1, decodedImage.height - top);

      final faceCrop =
          img.copyCrop(decodedImage, x: left, y: top, width: width, height: height);
      final embedding = _facenet.getEmbedding(faceCrop);

      if (embedding != null && widget.allEmployees != null) {
        Data? matchedEmployee;
        double bestScore = -1.0;

        for (final emp in widget.allEmployees!) {
          final storedEmbeddings = emp.biometricEmpId!
              .map<List<double>>(
                  (e) => (e as List).map<double>((v) => v.toDouble()).toList())
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
                embedding, matchedEmployee.employeeId.toString());
          } catch (e) {
            debugPrint("Controller verifyAttendance error: $e");
          }

          // ✅ Add delay after successful match
          debugPrint("⏳ Waiting 10 seconds before next scan...");
          await Future.delayed(const Duration(seconds: 3));

        } else {
          if (mounted) setState(() => _message = "⚠️ No Match Found. Try again.");
          await Future.delayed(const Duration(seconds: 2));
        }
      } else {
        if (mounted) setState(() => _message = "⚠️ No face detected or model error.");
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } else {
      if (mounted) setState(() => _message = "⚠️ No face detected. Try again!");
      await Future.delayed(const Duration(milliseconds: 500));
    }
  } catch (e) {
    debugPrint("Error capturing face: $e");
    if (mounted) setState(() => _message = "Error capturing face.");
    await Future.delayed(const Duration(seconds: 1));
  } finally {
    if (mounted) {
      setState(() {
        // Reset message based on dormant state
        _message =
            _isDormant ? "Sleeping... (no face detected)" : "Show your face to capture";
        _isCapturing = false;
      });
    }
  }
}

  // --- Registration capture (manual) ---
  Future<void> _captureForRegistration() async {
    if (_isCapturing || _cameraController == null || !mounted) return;
    setState(() => _isCapturing = true);

    try {
      final cameraImage = await _cameraController!.takePicture();
      final file = File(cameraImage.path);
      final imageBytes = await file.readAsBytes();

      final inputImage = InputImage.fromFilePath(cameraImage.path);
      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        final decodedImage = img.decodeImage(imageBytes)!;
        final rect = face.boundingBox;
        final left = rect.left.toInt().clamp(0, decodedImage.width - 1);
        final top = rect.top.toInt().clamp(0, decodedImage.height - 1);
        final width = rect.width.toInt().clamp(1, decodedImage.width - left);
        final height = rect.height.toInt().clamp(1, decodedImage.height - top);

        final faceCrop =
            img.copyCrop(decodedImage, x: left, y: top, width: width, height: height);
        final embedding = _facenet.getEmbedding(faceCrop);

        if (embedding != null) {
          _capturedEmbeddings.add(embedding);
          final remaining = widget.maxCaptures - _capturedEmbeddings.length;

          if (remaining > 0) {
            if (mounted) setState(() => _message =
                "✅ Captured face (${_capturedEmbeddings.length}/${widget.maxCaptures})");
          } else {
            if (mounted) setState(
                () => _message = "✅ All ${widget.maxCaptures} faces captured!");
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) Navigator.pop(context, _capturedEmbeddings);
          }
        } else {
          if (mounted) setState(() => _message = "Error generating embedding. Try again.");
        }
      } else {
        if (mounted) setState(() => _message = "⚠️ No face detected. Try again!");
      }
    } catch (e) {
      debugPrint("Registration capture error: $e");
      if (mounted) setState(() => _message = "Error. Try again.");
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  // Cosine similarity
double _cosineSimilarity(List<double> a, List<double> b) {
  if (a.length != b.length) {
    debugPrint("⚠️ Embedding length mismatch: a=${a.length}, b=${b.length}");
    return -1.0; // skip invalid comparisons
  }

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
    // Pause/resume camera appropriately to avoid resource leaks
    if (!mounted) return;
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      try {
        await _cameraController?.stopImageStream();
        await _cameraController?.dispose();
      } catch (e) {
        debugPrint("Lifecycle pause stop error: $e");
      }
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize camera & detector on resume
      await Future.delayed(const Duration(milliseconds: 300));
      await _initFaceDetector();
      await _initCameraController();
      // Reset last face detected time on resume
      _lastFaceDetectedTime = DateTime.now();
      if(mounted) setState(() => _isDormant = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _cameraRestartTimer?.cancel();
    _detectorRestartTimer?.cancel();

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
      return const Scaffold(
        body: Center(child: Text("Error: Camera not initialized.")),
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
                color: _isDormant
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
              label: const Text("Capture Face",
                  style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              backgroundColor: Colors.green,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}