import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// 图片缓存管理器
class CustomCacheManager {
  static final BaseCacheManager _instance = CacheManager(
    Config(
      'custom_cache_key',
      maxNrOfCacheObjects: 200, // 最大缓存文件数
      stalePeriod: Duration(days: 1), // 缓存过期时间
      repo: JsonCacheInfoRepository(databaseName: 'image_cache'),
    ),
  );

  static BaseCacheManager get instance => _instance;
}