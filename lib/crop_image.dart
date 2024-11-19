import 'package:flutter/material.dart';
import 'package:flutterkaigi_2024_lt/utils/image.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutterkaigi_2024_lt/vendor/screenshot.dart';

import 'dart:io';

class CropImagePage extends StatelessWidget {
  final XFile file;
  final ScreenshotController screenshotController = ScreenshotController();
  final TransformationController transformationController =
      TransformationController();

  CropImagePage({super.key, required this.file});

  Future<void> _captureAndCropScreenshot(BuildContext context) async {
    final screenSize = MediaQuery.sizeOf(context);
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final screenshot = await screenshotController.capture();
    if (screenshot case final ss) {
      final croppedImage = await _cropFromImage(
        ss,
        screenSize,
        pixelRatio,
      );
      if (croppedImage == null) {
        return;
      }
      await _saveImageToGallery(croppedImage);

      if (!context.mounted) return;
      Navigator.pop(context, croppedImage);
    }
  }

  Future<File?> _cropFromImage(ScreenshotCaptureResult? screenshot,
      Size screenSize, double pixelRatio) async {
    if (screenshot == null) {
      return null;
    }
    debugPrint('screenshot: ${screenshot.width}x${screenshot.height}');

    // クロップ領域のサイズ
    const padding = 32.0;
    final cropSize = (screenSize.width - padding * 2) * pixelRatio;

    // クロップ位置を計算
    final halfScreenshotWidth = screenshot.width / 2;
    final halfScreenshotHeight = screenshot.height / 2;
    final halfCropSize = cropSize / 2;

    final dx = halfScreenshotWidth - halfCropSize;
    final dy = halfScreenshotHeight - halfCropSize;

    debugPrint('dx: $dx, dy: $dy');

    final bytes = await ImageUtils.cropRGBA(
      screenshot.rgbaBytes,
      screenshot.width,
      screenshot.height,
      Rect.fromLTWH(dx, dy, cropSize, cropSize),
    );

    if (bytes == null) {
      return null;
    }

    final tempDir = Directory.systemTemp;
    final croppedFile =
        await File('${tempDir.path}/cropped_image.png').writeAsBytes(bytes);

    return croppedFile;
  }

  Future<void> _saveImageToGallery(File file) async {
    await GallerySaver.saveImage(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _captureAndCropScreenshot(context);
            },
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                transformationController: transformationController,
                clipBehavior: Clip.none,
                child: Image.file(
                  File(file.path),
                  fit: BoxFit.contain,
                ),
              ),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ClipPath(
                    clipper: CropOverlayClipper(
                      size: MediaQuery.of(context).size.width - 64.0,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withAlpha(124),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CropOverlayClipper extends CustomClipper<Path> {
  final double padding;
  final double size;

  CropOverlayClipper({this.padding = 32.0, required this.size});

  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTWH(
      padding,
      size.height / 2 - this.size / 2,
      this.size,
      this.size,
    );
    return Path()
      ..addRect(rect)
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
