import 'comment.dart';
import 'contents.dart';
import '../common/custom_html.dart';

class Detail {
  Detail({
    required this.id,
    required this.title,
    required this.type,
    required this.author,
    required this.updateDate,
    required this.rating,
    required this.words,
    required this.views,
    required this.favorite,
    required this.imgSrc,
    required this.nsfw,
    required this.tags,
    required this.description,
    required this.contents,
    required this.isFavorite,
    this.lastWatched,
    this.comments,
  });
  final int id; // 书籍id
  final String title; // 标题
  final String type; // 类型
  final String author; // 作者
  final String updateDate; // 更新日期
  final double rating; // 评分
  final int words; // 字数
  final int views; // 观看数
  final int favorite; // 喜欢数
  final String imgSrc; // 封面
  final bool nsfw; // 18+
  final List<String> tags; // 标签
  final CustomHtml description; // 简介
  final Contents contents; // 目录

  // 与用户有关的信息
  final bool isFavorite; // 已收藏
  final int? lastWatched; // 最后观看章节的id

  final List<Comment>? comments; // 评论

  Detail copyWith({
    int? id,
    String? title,
    String? type,
    String? author,
    String? updateDate,
    double? rating,
    int? words,
    int? views,
    int? favorite,
    String? imgSrc,
    bool? nsfw,
    List<String>? tags,
    CustomHtml? description,
    Contents? contents,
    bool? isFavorite,
    int? lastWatched,
    List<Comment>? comments,
  }) => Detail(
    id: id ?? this.id,
    title: title ?? this.title,
    type: type ?? this.type,
    author: author ?? this.author,
    updateDate: updateDate ?? this.updateDate,
    rating: rating ?? this.rating,
    words: words ?? this.words,
    views: views ?? this.views,
    favorite: favorite ?? this.favorite,
    imgSrc: imgSrc ?? this.imgSrc,
    nsfw: nsfw ?? this.nsfw,
    tags: tags ?? this.tags,
    description: description ?? this.description,
    contents: contents ?? this.contents,
    isFavorite: isFavorite ?? this.isFavorite,
    lastWatched: lastWatched ?? this.lastWatched,
    comments: comments ?? this.comments,
  );
}