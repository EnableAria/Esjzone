import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../common/manager.dart';

// 网络图片组件封装
class CustomNetImage extends StatelessWidget {
  const CustomNetImage(this.src, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.small = false,
  });
  final String src;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool small;
  final double smallDimension = 28;

  @override
  Widget build(BuildContext context) {
    if (_isSvgUrl(src)) {
      // svg格式表情
      return SvgPicture.network(
        src,
        width: small ? smallDimension : width,
        height: small ? smallDimension : height,
        fit: fit ?? BoxFit.contain,
        placeholderBuilder: (_) => small ? wProgressIndicator() : Center(child: wProgressIndicator()), // 加载展示圆形进度条
        errorBuilder: (_, _, _) => small ? Icon(Icons.error) : Center(child: Icon(Icons.error)), // 错误展示错误图标
      );
    }
    else {
      // 栅格图像格式
      return CachedNetworkImage(
        imageUrl: src,
        width: small ? smallDimension : width,
        height: small ? smallDimension : height,
        fit: fit,
        cacheManager: CustomCacheManager.instance,
        placeholder: (_, _) => small ? wProgressIndicator() : Center(child: wProgressIndicator()), // 加载展示圆形进度条
        errorWidget: (_, _, _) => small ? Icon(Icons.error) : Center(child: Icon(Icons.error)), // 错误展示错误图标
      );
    }
  }

  /// 加载进度条封装
  Widget wProgressIndicator() {
    return SizedBox.square(
      dimension: small ? smallDimension : null,
      child: CircularProgressIndicator(),
    );
  }

  /// 判断svg格式
  bool _isSvgUrl(String url) {
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();

    // 检查常见的 SVG 扩展名
    return path.endsWith('.svg') ||
        path.endsWith('.svgz') || // 压缩的 SVG
        path.contains('.svg?') || // 带查询参数的 SVG
        path.contains('.svg#') || // 带锚点的 SVG
        path.contains('.svg&');   // 带参数的 SVG
  }
}