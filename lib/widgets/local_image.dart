import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../common/manager.dart';

class LocalImage extends StatefulWidget {
  const LocalImage({
    super.key,
    required this.localKey,
    required this.refreshFlag,
  });
  final String localKey;
  final ValueNotifier<bool> refreshFlag;

  @override
  State<LocalImage> createState() => LocalImageState();
}

class LocalImageState extends State<LocalImage> {
  Uint8List? _bytes;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
    widget.refreshFlag.addListener(reload); // 绑定回调
  }

  @override
  void didUpdateWidget(covariant LocalImage oldWidget) {
    oldWidget.refreshFlag.dispose();
    widget.refreshFlag.addListener(reload); // 重新绑定回调
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Center(child: Icon(Icons.broken_image_outlined));
    }
    else if (_bytes == null) {
      return Center(child: SizedBox.square(child: CircularProgressIndicator()));
    }
    else {
      return Image.memory(_bytes!, fit: BoxFit.cover);
    }
  }

  /// 加载缓存图片
  Future<void> _loadImage() async {
    try {
      final bytes = await CoverCacheManager.loadCache(localKey: widget.localKey);
      setState(() {
        _bytes = bytes;
        _error = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  /// 更新方法
  void reload() => _loadImage();
}