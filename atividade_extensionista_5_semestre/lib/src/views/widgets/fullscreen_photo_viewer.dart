import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FullscreenPhotoViewer extends StatelessWidget {
  final String photoData; // Base64 or URL or file path
  final String category;

  const FullscreenPhotoViewer({
    super.key,
    required this.photoData,
    required this.category,
  });

  Uint8List? _decodeBase64Image(String str) {
    if (str.isEmpty || str.startsWith('http')) return null;
    if (str.startsWith('/data/') || str.startsWith('/storage/') || str.contains(':\\')) {
      return null;
    }
    try {
      String clean = str.trim();
      if (clean.contains(',')) {
        clean = clean.split(',').last;
      }
      return base64Decode(clean);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    final decodedBytes = _decodeBase64Image(photoData);

    if (decodedBytes != null) {
      imageWidget = Image.memory(decodedBytes, fit: BoxFit.contain);
    } else if (photoData.startsWith('http')) {
      imageWidget = Image.network(photoData, fit: BoxFit.contain);
    } else if (File(photoData).existsSync()) {
      imageWidget = Image.file(File(photoData), fit: BoxFit.contain);
    } else {
      imageWidget = const Center(child: Icon(Icons.image_not_supported, size: 64, color: Colors.white));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          category,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: SizedBox.expand(
            child: Center(child: imageWidget),
          ),
        ),
      ),
    );
  }
}
