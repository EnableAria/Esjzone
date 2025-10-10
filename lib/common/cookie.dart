/// 解码Cookie
Map<String, String> cookieDecode(List<String> cookieList) {
  Map<String, String> result = {};
  for (String cookieItem in cookieList) {
    // 分割多个 Cookie(如果有)
    List<String> cookieSplit = cookieItem.split(',');

    for (String cookieStr in cookieSplit) {
      // 分割键值对
      List<String> cookie = cookieStr.split(';');
      String firstPart = cookie[0].trim();

      // 绑定键值
      if (firstPart.contains('=')) {
        int equalsIndex = firstPart.indexOf('=');
        String key = firstPart.substring(0, equalsIndex);
        String value = firstPart.substring(equalsIndex + 1);
        result[key] = value;
      }
    }
  }
  return result;
}

/// 编码Cookie
String cookieEncode(Map<String, String> cookieMap){
  String result = "";
  cookieMap.forEach((key, value) => result += "$key=$value");
  return result;
}