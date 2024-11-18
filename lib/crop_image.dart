import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';

class CropImagePage extends StatelessWidget {
  final XFile file;
  final ScreenshotController screenshotController = ScreenshotController();
  final TransformationController transformationController =
      TransformationController();

  CropImagePage({super.key, required this.file});

  Future<void> _captureAndCropScreenshot(BuildContext context) async {
    final screenshot = await screenshotController.capture();

    if (screenshot case final ss?) {
      if (!context.mounted) return;
      final viewportSize = MediaQuery.of(context).size;
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final croppedImage = await _cropCircleFromImage(
        ss,
        transformationController.value,
        viewportSize,
        pixelRatio,
      );

      await _saveImageToGallery(croppedImage);

      if (!context.mounted) return;
      Navigator.pop(context, croppedImage);
    }
  }

  Future<File> _cropCircleFromImage(Uint8List screenshot, Matrix4 matrix,
      Size viewportSize, double pixelRatio) async {
    final codec = await instantiateImageCodec(screenshot);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    // スケールと平行移動を取得
    final scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();

    // クロップ領域のサイズ
    const padding = 32.0;
    final cropSize = (viewportSize.width - padding * 2) * pixelRatio;

    // クロップ位置を計算
    final dx = ((image.width / scale - cropSize) / 2 -
                translation.x / scale * pixelRatio)
            .round() -
        32;
    final dy = ((image.height / scale - cropSize) / 2 -
                translation.y / scale * pixelRatio)
            .round() -
        32;

    // 正方形クロップのサイズを計算
    final size = cropSize.round();

    final recorder = PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));

    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;

    // クロップ領域を描画
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(dx.toDouble(), dy.toDouble(), cropSize, cropSize),
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      paint,
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final tempDir = Directory.systemTemp;
    final croppedFile =
        await File('${tempDir.path}/cropped_image.png').writeAsBytes(pngBytes);

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
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: InteractiveViewer(
                transformationController: transformationController,
                clipBehavior: Clip.none,
                child: Image.file(
                  File(file.path),
                  fit: BoxFit.cover,
                ),
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
