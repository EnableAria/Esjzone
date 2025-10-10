class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.latestChapter,
    required this.rating,
    required this.ratingCount,
    required this.words,
    required this.views,
    required this.favorite,
    required this.articles,
    required this.comments,
    required this.imgSrc,
    this.nsfw = false,
  });
  final int id; // 书籍id
  final String title; // 标题
  final String author; // 作者
  final String latestChapter; // 最新章节
  final double rating; // 评分
  final int ratingCount; // 评分人数
  final int words; // 字数
  final int views; // 观看数
  final int favorite; // 收藏数
  final int articles; // 文章数
  final int comments; // 讨论数
  final String imgSrc; // 封面
  final bool nsfw; // 18+
}