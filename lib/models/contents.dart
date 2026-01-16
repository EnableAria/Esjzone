class Contents {
  Contents({
    this.total = 0,
    this.contents = const [],
  });
  int total; // 章节总数
  List<SubContents> contents; // 章节列表
}

class SubContents {
  SubContents({
    this.contentsTitle,
    required this.chapter,
  });
  String? contentsTitle; // 列表标题
  List<Chapter> chapter; // 章节列表

  bool get isSub => contentsTitle != null;
}

class Chapter {
  Chapter({
    required this.id,
    required this.title,
  });
  final int id;
  final String title;
}