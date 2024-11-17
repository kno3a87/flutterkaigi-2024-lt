import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterkaigi_2024_lt/utils/emoji.dart';

TextSpan emojiScaledTextSpan({
  required String text,
  required TextStyle style,
  GestureRecognizer? recognizer,
  required double originalFontSize,
}) {
  final textStyle = style.copyWith(color: style.color ?? Colors.black);
  final emojiStyle = _emojiStyle(textStyle, originalFontSize);

  final spans = EmojiSplitter.split(text).map((block) {
    if (block.isEmoji) {
      return TextSpan(
        text: block.text,
        style: emojiStyle,
      );
    } else {
      return TextSpan(
        text: block.text,
        style: textStyle,
      );
    }
  }).toList();
  return TextSpan(
    children: spans,
    style: textStyle,
  );
}

TextStyle _emojiStyle(TextStyle textStyle, double originalFontSize) {
  if (Platform.isAndroid) {
    return textStyle;
  } else {
    return textStyle.copyWith(
      fontSize: textStyle.fontSize! * 1.4,
      fontFamilyFallback: [],
      height: 1.0,
    );
  }
}
