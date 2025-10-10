import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../common/manager.dart';

// 网络图片组件封装
class CustomNetImage extends StatelessWidget {
  const CustomNetImage(this.src, {
    super.key,
    this.width,
    this.height,
    this.fit,
  });
  final String src;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src,
      width: width,
      height: height,
      fit: fit,
      cacheManager: CustomCacheManager.instance,
      placeholder: (_, _) => Center(child: CircularProgressIndicator()), // 加载展示圆形进度条
      errorWidget: (_, _, _) => Center(child: Icon(Icons.error)), // 错误展示错误图标
    );
  }
}