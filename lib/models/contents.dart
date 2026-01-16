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
    this.updateDate,
  });
  final int id; // 章节id
  final String title; // 标题
  final String? updateDate; // 更新日期

  Chapter copyWith({
    int? id,
    String? title,
    String? updateDate,
  }) => Chapter(
    id: id ?? this.id,
    title: title ?? this.title,
    updateDate: updateDate ?? this.updateDate,
  );

  @override
  bool operator ==(Object other) {
    return other is Chapter && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 更新章节更新日期
Contents updateChapterDate({
  required Contents contents,
  required Map<int, String> updateDate,
}) {
  updateDate.forEach((id, date) {
    for (SubContents sub in contents.contents) {
      if (sub.chapter.contains(Chapter(id: id, title: ""))) {
        int index = sub.chapter.indexWhere((c) => c.id == id);
        sub.chapter[index] = sub.chapter[index].copyWith(updateDate: date);
        break;
      }
    }
  });
  return contents;
}