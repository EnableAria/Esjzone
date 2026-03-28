import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/network_image.dart';

// 比例图片组件(书籍封面)
class RatioImage extends StatelessWidget {
  const RatioImage({
    super.key,
    required this.child,
    this.aspectRatio = 1 / sqrt2,
  });
  RatioImage.network({
    super.key,
    String? src,
    String? cacheKey,
    bool cache = false,
    this.aspectRatio = 1 / sqrt2,
  }) : child = (src == null
      ? SizedBox()
      : CustomNetImage(
    src,
    fit: BoxFit.cover,
    cacheKey: cacheKey,
    cache: cache,
  ));
  final Widget child;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio, // 固定宽高比
      child: child,
    );
  }
}