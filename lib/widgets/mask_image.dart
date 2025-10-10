import '../widgets/network_image.dart';
import 'package:flutter/material.dart';

// 渐变图片组件
class MaskImage extends StatelessWidget {
  const MaskImage({
    super.key,
    required this.imgSrc,
    this.width,
    this.height,
  });
  final String imgSrc;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor
                .withValues(alpha: 0.4), // 顶部
            Colors.transparent,// 底部
          ],
          stops: [0.0, 1.0], // 渐变位置
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: CustomNetImage(
        imgSrc,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}