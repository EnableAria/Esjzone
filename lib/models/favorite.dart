class Favorite {
  Favorite({
    required this.id,
    required this.title,
    required this.latestChapter,
    required this.updateDate,
    this.lastWatched,
  });
  final int id; // 书籍id
  final String title; // 标题
  final String latestChapter; // 最新章节
  final String updateDate; // 更新日期
  final String? lastWatched; // 最后观看
}