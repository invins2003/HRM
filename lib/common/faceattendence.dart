// [FaceNetService class remains unchanged as provided in your prompt]
// ... (Your FaceNetService code) ...
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

// Your FaceNetService class (unchanged)
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

// --- CORRECTED STATE CLASS ---

class FaceProcessingScreen extends StatefulWidget {
  final int maxCaptures;
  final CameraDescription camera;

  const FaceProcessingScreen({
    super.key,
    required this.camera,
    this.maxCaptures = 1,
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
  final List<List<double>> _capturedEmbeddings = [];

  bool _loading = true;
  String _message = "Show your face to capture"; // Updated initial message

  CameraDescription? _currentCamera;
  List<CameraDescription>? _availableCameras;

  // Flags to control processing
  bool _isProcessingStream = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() => _loading = true);
    await _facenet.loadModel();

    _availableCameras = await availableCameras();

    // --- DEFAULT TO FRONT CAMERA ---
    try {
      // Find the front camera
      _currentCamera = _availableCameras?.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
      );
    } catch (e) {
      // If front camera not found, fallback to widget.camera or first available
      _currentCamera = widget.camera ?? _availableCameras?.first;
    }
    // ----------------------------------------

    if (_currentCamera == null) {
      debugPrint("Error: No cameras available.");
      setState(() => _loading = false);
      return;
    }

    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup
                .nv21 // Request NV21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();

    // Start the image stream for live feedback
    await _cameraController!.startImageStream(_onImageStream);

    setState(() => _loading = false);
  }

  // Handle image stream for live detection feedback
  Future<void> _onImageStream(CameraImage image) async {
    if (_isProcessingStream || _isCapturing) return;
    if (_capturedEmbeddings.length >= widget.maxCaptures) {
      await _cameraController?.stopImageStream();
      return;
    }

    _isProcessingStream = true;

    try {
      final inputImage = _createInputImageFromCameraImage(image);
      if (inputImage == null) {
        _isProcessingStream = false;
        return;
      }

      final faces = await _faceDetector.processImage(inputImage);

      // --- AUTOMATIC CAPTURE ENABLED ---
      if (faces.isNotEmpty && mounted && !_isCapturing) {
        // Face detected!
        setState(() {
          _message = "✅ Face detected! Stand still...";
        });
        // Trigger the high-res capture
        await _captureFace(); // This line is restored
      } else if (mounted && !_isCapturing) {
        // Update message to show "looking"
        setState(() {
          _message = "Show your face to capture";
        });
      }
      // -------------------------------------------
    } catch (e) {
      debugPrint("Error in image stream processing: $e");
    } finally {
      _isProcessingStream = false;
    }
  }

  // Helper to create InputImage from CameraImage
  InputImage? _createInputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    // Tell ML Kit the format is NV21
    final InputImageFormat format = Platform.isAndroid
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;

    // --- THIS IS THE FIX ---
    // Check for the format we actually requested (nv21)
    if (image.format.group !=
        (Platform.isAndroid
            ? ImageFormatGroup
                  .nv21 // <--- MUST MATCH WHAT WE REQUESTED
            : ImageFormatGroup.bgra8888)) {
      debugPrint("Unexpected image format ${image.format.group}");
      return null;
    }
    // -----------------------

    final allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final rotation = _getInputImageRotation();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: format, // Use InputImageFormat.nv21
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

    // Stop stream before disposing
    try {
      if (_cameraController?.value.isStreamingImages == true) {
        await _cameraController?.stopImageStream();
      }
    } catch (e) {
      debugPrint(
        "Warning: Camera stream already stopped or error stopping: $e",
      );
    }
    await _cameraController?.dispose();

    // Find the *other* camera
    _currentCamera = _availableCameras!.firstWhere(
      (cam) => cam.lensDirection != _currentCamera!.lensDirection,
      orElse: () => _availableCameras!.first, // fallback
    );

    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup
                .nv21 // Also apply here
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();

    // Restart the stream
    await _cameraController!.startImageStream(_onImageStream);

    setState(() {});
  }

  // This function is now called automatically OR by the button
  Future<void> _captureFace() async {
    if (_capturedEmbeddings.length >= widget.maxCaptures) return;
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

        setState(() {
          _message =
              "✅ Captured face (${_capturedEmbeddings.length + 1}/${widget.maxCaptures})";
        });

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
          if (_capturedEmbeddings.length >= widget.maxCaptures) {
            // Stop stream when done
            try {
              if (_cameraController?.value.isStreamingImages == true) {
                await _cameraController?.stopImageStream();
              }
            } catch (e) {
              debugPrint(
                "Warning: Camera stream already stopped or error stopping: $e",
              );
            }
            if (mounted) {
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
    } finally {
      if (mounted) {
        // Add a small delay before allowing another auto-capture
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => _isCapturing = false); // Clear flag
      }
    }
  }

  @override
  void dispose() {
    // Stop stream before disposing controller
    try {
      if (_cameraController?.value.isStreamingImages == true) {
        _cameraController?.stopImageStream();
      }
    } catch (e) {
      debugPrint(
        "Warning: Camera stream already stopped or error stopping: $e",
      );
    }
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _captureFace, // Button still works for manual capture
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
