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