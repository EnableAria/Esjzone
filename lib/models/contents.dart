class Contents {
  Contents({
    this.total = 0,
    this.contents = const [],
  });
  int total;
  List<SubContents> contents;
}

class SubContents {
  SubContents({
    this.contentsTitle,
    required this.chapter,
  });
  String? contentsTitle;
  List<Chapter> chapter;

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