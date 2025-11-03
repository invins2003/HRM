// [FaceNetService class remains unchanged as provided in your prompt]
// ... (Your FaceNetService code) ...
import 'dart:typed_data';
import 'dart:io';
import 'dart:math'; // <-- IMPORT MATH
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

// Import the controller and model
import 'package:erp_admin/module/DashBoard/Controller/EmployeeListController.dart';
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';


// --- FaceNetService Class (Unchanged) ---
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
// [End of FaceNetService class]


// --- MODIFIED STATE CLASS (HANDLES BOTH MODES) ---

class FaceProcessingScreen extends StatefulWidget {
  final int maxCaptures; // For registration (e.g., 3)
  final CameraDescription camera;
  final List<Data>? allEmployees; // OPTIONAL: For attendance mode
  final DashBoardEmployeeList? controller; // OPTIONAL: For attendance mode

  const FaceProcessingScreen({
    super.key,
    required this.camera,
    this.maxCaptures = 1, // Default to 1, registration will pass 3
    this.allEmployees,
    this.controller,
  });

  @override
  State<FaceProcessingScreen> createState() => _FaceProcessingScreenState();
}

class _FaceProcessingScreenState extends State<FaceProcessingScreen> {
  CameraController? _cameraController;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  final FaceNetService _facenet = FaceNetService();
  
  // List for registration captures
  final List<List<double>> _capturedEmbeddings = [];

  bool _loading = true;
  String _message = "Initializing...";

  CameraDescription? _currentCamera;
  List<CameraDescription>? _availableCameras;

  bool _isProcessingStream = false;
  bool _isCapturing = false;

  // --- NEW: Mode flag ---
  bool _isAttendanceMode = false;

  @override
  void initState() {
    super.initState();
    _currentCamera = widget.camera;

    // --- SET THE MODE ---
    _isAttendanceMode = widget.allEmployees != null && widget.controller != null;

    if (_isAttendanceMode) {
      _message = "Show your face to capture"; // Attendance message
    } else {
      _message = "Show your face and tap capture (0/${widget.maxCaptures})"; // Registration message
    }
    
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() => _loading = true);
    await _facenet.loadModel();
    _availableCameras = await availableCameras();

    if (_currentCamera == null) {
      debugPrint("Error: No camera provided.");
      setState(() => _loading = false);
      return;
    }

    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // Request NV21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();

    // --- CONDITIONAL STREAM ---
    if (_isAttendanceMode) {
      // Only start the stream in attendance mode
      await _cameraController!.startImageStream(_onImageStream);
    }

    setState(() => _loading = false);
  }

  // Handle image stream (ONLY RUNS IN ATTENDANCE MODE)
  Future<void> _onImageStream(CameraImage image) async {
    if (_isProcessingStream || _isCapturing) return;

    _isProcessingStream = true;

    try {
      final inputImage = _createInputImageFromCameraImage(image);
      if (inputImage == null) {
        _isProcessingStream = false;
        return;
      }

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty && mounted && !_isCapturing) {
        // Face detected!
        setState(() {
          _message = "✅ Face detected! Verifying...";
        });
        // Trigger the high-res capture and matching
        await _captureAndMatchFace();
      } else if (mounted && !_isCapturing) {
        // Update message to show "looking"
        setState(() {
          _message = "Show your face to capture";
        });
      }
    } catch (e) {
      debugPrint("Error in image stream processing: $e");
    } finally {
      _isProcessingStream = false;
    }
  }

  // Helper to create InputImage from CameraImage
  InputImage? _createInputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;
    
    final InputImageFormat format = Platform.isAndroid
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;

    if (image.format.group != (Platform.isAndroid 
          ? ImageFormatGroup.nv21 
          : ImageFormatGroup.bgra8888)) {
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

  // Helper for rotation
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

  Future<void> _switchCamera() async {
    if (_availableCameras == null || _availableCameras!.length < 2) return;

    if (_isAttendanceMode) await _cameraController?.stopImageStream();
    await _cameraController?.dispose();

    _currentCamera = _availableCameras!.firstWhere(
      (cam) => cam.lensDirection != _currentCamera!.lensDirection,
      orElse: () => _availableCameras!.first,
    );

    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();
    
    // --- CONDITIONAL STREAM RESTART ---
    if (_isAttendanceMode) {
      await _cameraController!.startImageStream(_onImageStream);
    }
    setState(() {});
  }

  // --- Logic for ATTENDANCE MODE (Continuous) ---
  Future<void> _captureAndMatchFace() async {
    if (_isCapturing) return; 
    if (_cameraController == null) return;

    setState(() => _isCapturing = true); // Lock capturing

    try {
      final cameraImage = await _cameraController!.takePicture();
      final file = File(cameraImage.path);
      final imageBytes = await file.readAsBytes();

      final inputImage = InputImage.fromFilePath(cameraImage.path);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        final decodedImage = img.decodeImage(imageBytes)!;
        final rect = face.boundingBox;
        final faceCrop = img.copyCrop(
          decodedImage,
          x: rect.left.toInt().clamp(0, decodedImage.width - 1),
          y: rect.top.toInt().clamp(0, decodedImage.height - 1),
          width: rect.width.toInt().clamp(1, decodedImage.width),
          height: rect.height.toInt().clamp(1, decodedImage.height),
        );

        final embedding = _facenet.getEmbedding(faceCrop);
        
        if (embedding != null) {
          Data? matchedEmployee;
          double bestScore = 0;

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

          if (matchedEmployee != null && bestScore >= 0.6) {
            setState(() {
              _message = "✅ ${matchedEmployee!.name} Verified!";
            });
            
            // Run verification in the background
            widget.controller!.verifyAttendance(
              embedding,
              matchedEmployee.employeeId.toString(),
            );
            
            await Future.delayed(const Duration(seconds: 2)); 

          } else {
            setState(() {
              _message = "⚠️ No Match Found. Try again.";
            });
            await Future.delayed(const Duration(seconds: 2));
          }
        }
      } else {
        setState(() {
          _message = "⚠️ No face detected. Try again!";
        });
         await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      debugPrint("Error capturing face: $e");
      setState(() { _message = "Error capturing face."; });
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      if(mounted) {
         setState(() {
           _message = "Show your face to capture";
           _isCapturing = false; // Allow _onImageStream to trigger again
         });
      }
    }
  }

  // --- Logic for REGISTRATION MODE (Manual Capture) ---
  Future<void> _captureForRegistration() async {
    if (_isCapturing) return; // Prevent concurrent captures
    if (_cameraController == null) return;

    setState(() => _isCapturing = true);

    try {
      final cameraImage = await _cameraController!.takePicture();
      final file = File(cameraImage.path);
      final imageBytes = await file.readAsBytes();

      final inputImage = InputImage.fromFilePath(cameraImage.path);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        final decodedImage = img.decodeImage(imageBytes)!;
        final rect = face.boundingBox;
        final faceCrop = img.copyCrop(
          decodedImage,
          x: rect.left.toInt().clamp(0, decodedImage.width - 1),
          y: rect.top.toInt().clamp(0, decodedImage.height - 1),
          width: rect.width.toInt().clamp(1, decodedImage.width),
          height: rect.height.toInt().clamp(1, decodedImage.height),
        );

        final embedding = _facenet.getEmbedding(faceCrop);
        if (embedding != null) {
          _capturedEmbeddings.add(embedding);
          
          final remaining = widget.maxCaptures - _capturedEmbeddings.length;
          
          if (remaining > 0) {
              setState(() {
                _message = "✅ Captured face (${_capturedEmbeddings.length}/${widget.maxCaptures})";
              });
          } else {
              setState(() {
                _message = "✅ All ${widget.maxCaptures} faces captured!";
              });
              
              // Wait for a second so user can see the message
              await Future.delayed(const Duration(seconds: 1));

              if(mounted) {
                Navigator.pop(context, _capturedEmbeddings);
              }
          }
        }
      } else {
        setState(() {
          _message = "⚠️ No face detected. Try again!";
        });
      }
    } catch (e) {
      debugPrint("Error capturing face: $e");
      setState(() => _message = "Error. Try again.");
    } finally {
      if(mounted) {
          setState(() => _isCapturing = false); // Clear flag
      }
    }
  }

  // --- Cosine Similarity (Used by attendance mode) ---
  double _cosineSimilarity(List<double> a, List<double> b) {
    assert(a.length == b.length);
    double dot = 0.0, normA = 0.0, normB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    return dot / (sqrt(normA) * sqrt(normB));
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _faceDetector.close();
    _facenet.dispose();
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
          CameraPreview(_cameraController!), // Camera preview
          // Overlay message
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.8),
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

          // Switch Camera Button
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
          
          // Back Button
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
      // --- CONDITIONAL FLOATING ACTION BUTTON ---
      floatingActionButton: _isAttendanceMode 
        ? null // No FAB in continuous attendance mode
        : FloatingActionButton.extended(
            onPressed: _captureForRegistration, // Call registration logic
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