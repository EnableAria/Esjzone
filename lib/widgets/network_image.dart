import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../common/manager.dart';
import '../common/network.dart';
import '../common/parse_html.dart';

// 网络图片组件封装
class CustomNetImage extends StatelessWidget {
  CustomNetImage(String src, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.cacheKey,
    this.small = false,
    this.cache = false,
  }) : src = extractSrc(src);
  final String src;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String? cacheKey;
  final bool small;
  final double smallDimension = 28;
  final bool cache; // 启用缓存

  @override
  Widget build(BuildContext context) {
    if (_isSvgUrl(src)) {
      // svg格式表情
      return SvgPicture.network(
        src,
        width: small ? smallDimension : width,
        height: small ? smallDimension : height,
        fit: fit ?? BoxFit.contain,
        placeholderBuilder: (_) => wProgressIndicator(), // 加载展示圆形进度条
        errorBuilder: (_, _, _) => small ? Icon(Icons.error) : Center(child: Icon(Icons.error)), // 错误展示错误图标
      );
    }
    else if (src == "${Esjzone.dio.options.baseUrl}/assets/img/empty.jpg" || src.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "No\nImage",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    else {
      // 栅格图像格式
      return cache
          ? CachedNetworkImage(
        imageUrl: src,
        width: small ? smallDimension : width,
        height: small ? smallDimension : height,
        fit: fit,
        cacheKey: cacheKey,
        cacheManager: CustomCacheManager.tempCache,
        memCacheWidth: 320, // 内存缓存宽度限制
        placeholder: (_, _) => wProgressIndicator(), // 加载展示圆形进度条
        errorWidget: (_, _, _) => small ? Icon(Icons.error) : Center(child: Icon(Icons.error)), // 错误展示错误图标
      )
          : Image.network(
        src,
        width: small ? smallDimension : width,
        height: small ? smallDimension : height,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          if (frame == null) return wProgressIndicator();
          return child;
        },
        errorBuilder: (_, _, _) => small ? Icon(Icons.error) : Center(child: Icon(Icons.error)), // 错误展示错误图标
      );
    }
  }

  /// 加载进度条封装
  Widget wProgressIndicator() {
    return small
        ? SizedBox.square(
      dimension: smallDimension,
      child: CircularProgressIndicator(),
    )
        : Center(child: SizedBox.square(
      child: CircularProgressIndicator(),
    ));
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