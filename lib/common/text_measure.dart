import 'package:flutter/material.dart';

/// 测量文本宽度
double measureTextWidth(String text, TextStyle style) {
  return (TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout()).width;
}