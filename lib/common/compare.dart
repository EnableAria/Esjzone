/// 版本比较
int versionCompare(String ver_1, String ver_2) {
  RegExp versionRegex = RegExp(r'^v?(\d+).(\d+).(\d+)');
  Match? match_1 = versionRegex.firstMatch(ver_1);
  Match? match_2 = versionRegex.firstMatch(ver_2);
  if (match_1 != null && match_2 != null) {
    for (int i = 1; i <= 3; i++) {
      int number_1 = int.parse(match_1.group(i) ?? "0");
      int number_2 = int.parse(match_2.group(i) ?? "0");
      if (number_1 > number_2) { return 1; }
      else if (number_1 < number_2) { return -1; }
    }
  }
  return 0;
}

/// 判断最新版本
bool isNewVersion(String ver_1, String ver_2) => versionCompare(ver_1, ver_2) > 0;

/// 时间比较
int dateCompare(String date_1, String date_2) {
  RegExp dateRegex = RegExp(r'(\d+)/(\d+)/(\d+)');
  Match? match_1 = dateRegex.firstMatch(date_1);
  Match? match_2 = dateRegex.firstMatch(date_2);
  if (match_1 != null && match_2 != null) {
    for (int i = 1; i <= 3; i++) {
      int number_1 = int.parse(match_1.group(i) ?? "0");
      int number_2 = int.parse(match_2.group(i) ?? "0");
      if (number_1 > number_2) { return 1; }
      else if (number_1 < number_2) { return -1; }
    }
  }
  return 0;
}

/// 判断最新章节
bool isNewChapter(String date_1, String date_2) => versionCompare(date_1, date_2) >= 0;