import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

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
  String _message = "Show your face and tap capture";

  CameraDescription? _currentCamera;
  List<CameraDescription>? _availableCameras;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() => _loading = true);
    await _facenet.loadModel();

    _availableCameras = await availableCameras();
    _currentCamera = widget.camera;

    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController!.initialize();
    setState(() => _loading = false);
  }

  Future<void> _switchCamera() async {
    if (_availableCameras == null || _availableCameras!.length < 2) return;

    final currentIndex = _availableCameras!.indexOf(_currentCamera!);
    final newIndex = (currentIndex + 1) % _availableCameras!.length;
    _currentCamera = _availableCameras![newIndex];

    await _cameraController?.dispose();
    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _captureFace() async {
    if (_capturedEmbeddings.length >= widget.maxCaptures) return;

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
            Navigator.pop(context, _capturedEmbeddings);
          }
        }
      } else {
        setState(() {
          _message = "⚠️ No face detected. Try again!";
        });
      }
    } catch (e) {
      debugPrint("Error capturing face: $e");
    }
  }

  @override
  void dispose() {
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_cameraController != null &&
              _cameraController!.value.isInitialized)
            CameraPreview(_cameraController!), // Keep camera preview same
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
        onPressed: _captureFace,
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
