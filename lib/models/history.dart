class History {
  History({
    required this.bookId,
    required this.viewId,
    required this.lastWatchedId,
    required this.title,
    required this.lastWatched,
  });
  final int bookId; // 书籍id
  final int viewId; // 历史记录id
  final int lastWatchedId; // 最后观看章节id
  final String title; // 标题
  final String lastWatched; // 最后观看
}