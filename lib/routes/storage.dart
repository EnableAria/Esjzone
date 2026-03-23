import 'package:flutter/material.dart';
import '../common/manager.dart';

// 设置路由页
class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StatefulWidget> createState() => StoragePageState();
}

class StoragePageState extends State<StoragePage> {
  String? coverCache;

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  // 获取缓存占用
  Future<void> _loadCacheSize() async {
    try {
      final size = await CoverCacheManager.getCacheSize(key: "cover_cache");
      setState(() { coverCache = size; });
    }
    catch (e) { setState(() { coverCache = "Error"; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              coverCache ?? "正在获取...",
              style: TextStyle(fontSize: 40),
            ),
            Text("封面缓存占用"),
            Padding(padding: EdgeInsets.only(top: 40)),
            ElevatedButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                backgroundColor: Theme.of(context).colorScheme.primary, // 背景色
                foregroundColor: Theme.of(context).colorScheme.onPrimary, // 前景色(文字)
              ),
              onPressed: () async {
                if (coverCache != null) {
                  final size = await CoverCacheManager.clearCache(key: "cover_cache");
                  setState(() { coverCache = size; });
                }
              },
              child: Text(coverCache != null ? "清空缓存 $coverCache" : "正在获取"),
            )
          ],
        ),
      ),
    );
  }
}