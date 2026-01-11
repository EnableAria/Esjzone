import 'package:flutter/services.dart' show rootBundle;

/// 获取应用版本
Future<String?> getVersion() async {
  final contents = await rootBundle.loadString('pubspec.yaml');

  for (final line in contents.split('\n')) {
    if (line.startsWith('version:')) {
      return line.split(':').last.trim();
    }
  }

  return null;
}