import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String url;
  const ImageViewerScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Viewer")),
      body: Center(
        child: Image.network(url, fit: BoxFit.contain),
      ),
    );
  }
}
