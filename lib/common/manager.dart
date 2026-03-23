import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../common/parse_html.dart';
import 'format.dart';

// 图片缓存管理器
class CustomCacheManager {
  static final BaseCacheManager _tempCache = CacheManager(
    Config(
      'custom_cache_key',
      maxNrOfCacheObjects: 200, // 最大缓存文件数
      stalePeriod: Duration(days: 1), // 缓存过期时间
      repo: JsonCacheInfoRepository(databaseName: 'temp_image_cache'),
    ),
  );

  static BaseCacheManager get tempCache => _tempCache;
}

// 封面缓存管理器
class CoverCacheManager {
  static String? _dirPath;
  static Future<String> get dirPath async { // 数据路径
    _dirPath ??= (await getApplicationDocumentsDirectory()).path;
    return _dirPath!;
  }

  /// 缓存封面图片
  static Future<void> saveCache({
    required String localKey,
    required String src,
    bool update = false, // 是否强制更新缓存(为false时如有数据则不更新)
  }) async {
    try {
      final file = File('${await dirPath}/cover_cache/$localKey.jpg');
      if (!update && await file.exists()) return; // 跳过缓存更新

      final response = await Dio().get(
        extractSrc(src),
        options: Options(responseType: ResponseType.bytes),
      );
      Uint8List bytes = Uint8List.fromList(response.data); // 图像字节流

      img.Image? image = img.decodeImage(bytes);
      if (image != null) {
        // 压缩为JPG图片(GIF仅保留第一帧)
        image = img.copyResize(image, width: 320);
        Uint8List cacheBytes = Uint8List.fromList(img.encodeJpg(image, quality: 80));

        // 缓存压缩图片
        await file.parent.create(recursive: true);
        await file.writeAsBytes(cacheBytes);
      }
    } catch (e) {
    }
  }

  /// 加载缓存图片
  static Future<Uint8List> loadCache({
    required String localKey
  }) async => await File('${await dirPath}/cover_cache/$localKey.jpg').readAsBytes();

  /// 删除缓存图片
  static Future<void> deleteCache({
    required String localKey
  }) async {
    final file = File('${await dirPath}/cover_cache/$localKey.jpg');
    if (await file.exists()) await file.delete();
  }

  /// 获取缓存占用
  static Future<String> getCacheSize({required String key}) async {
    return formatBytes(await _getDirectorySize(Directory("${await dirPath}/$key")));
  }

  /// 计算目录空间
  static Future<int> _getDirectorySize(Directory directory) async {
    int totalSize = 0;

    try {
      final List<FileSystemEntity> entities = await directory.list().toList();

      for (final entity in entities) {
        if (entity is File) { // 获取文件大小
          totalSize += await entity.length();
        } else if (entity is Directory) { // 递归子目录
          totalSize += await _getDirectorySize(entity);
        }
      }
    } catch (_) { }

    return totalSize;
  }

  /// 清空目录缓存
  static Future<String> clearCache({required String key}) async {
    try {
      final directory = Directory("${await dirPath}/$key");

      if (await directory.exists()) await directory.delete(recursive: true);
      await directory.create(recursive: true); // 重建目录
    } catch (_) { }

    return await getCacheSize(key: key);
  }
}