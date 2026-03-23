import 'dart:math';

/// 格式化数字(每3位添加逗号)
String formatNumber(int number) {
  return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},'
  );
}

/// 格式化数字(字数统计)
String formatWordNumber(int number) {
  int index = max(0, (log(number) / log(1000)).floor() - 1);
  List<String> unit = ["", "k", "m", "b"];
  return "${number ~/ pow(1000, index)}${unit[index]}";
}

/// 格式化存储(空间占用)
String formatBytes(int number) {
  if (number <= 0) return "0 B";
  int index = max(0, (log(number) / log(1024)).floor());
  List<String> unit = ["B", "KB", "MB", "GB", "TB"];
  return "${(number / pow(1024, index)).toStringAsFixed(2)} ${unit[index]}";
}