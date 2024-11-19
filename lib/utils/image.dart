import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _channelName = 'utils_image';
const _cropRGBAMethodName = 'crop_rgba';

abstract class ImageUtils {
  static const _channel = MethodChannel(_channelName);

  static Future<Uint8List?> cropRGBA(
    Uint8List srcBytes,
    int srcWidth,
    int srcHeight,
    Rect rect, {
    bool png = false,
    int roundCorner = 0,
  }) async {
    try {
      final params = <String, dynamic>{
        'bytes': srcBytes,
        'srcWidth': srcWidth,
        'srcHeight': srcHeight,
        'length': srcBytes.length,
        'width': rect.width.toInt(),
        'height': rect.height.toInt(),
        'top': rect.top.toInt(),
        'left': rect.left.toInt(),
        'roundCorner': roundCorner,
        'png': png,
      };
      final result =
          await _channel.invokeMethod<Uint8List>(_cropRGBAMethodName, params);
      return result!;
    } catch (e) {
      debugPrint('cropRGBA error: $e');
    }
    return null;
  }
}
