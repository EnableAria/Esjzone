import 'package:flutter/material.dart';
import '../widgets/network_image.dart';

// 比例图片组件(书籍封面)
class RatioImage extends StatelessWidget {
  const RatioImage({
    super.key,
    required this.imgSrc,
    this.aspectRatio = 1 / 1.45,
  });
  final String imgSrc;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio, // 固定宽高比
      child: CustomNetImage(
        imgSrc,
        fit: BoxFit.cover,
      ),
    );
  }
}