import 'comment.dart';
import '../common/custom_html.dart';

class ChapterContent {
  ChapterContent({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.updateDate,
    required this.like,
    required this.words,
    this.prevChapterId,
    this.nextChapterId,
    required this.isLike,
    this.comments,
  });
  final int id; // 章节id
  final String title; // 章节标题
  final CustomHtml content; // 章节内容
  final String author; // 作者
  final String updateDate; // 更新日期
  final int like; // 点赞数
  final int words; // 字数
  final int? prevChapterId; // 上章id
  final int? nextChapterId; // 下章id

  // 与用户有关的信息
  final bool isLike; // 是否喜欢

  final List<Comment>? comments; // 评论

  ChapterContent copyWith({
    int? id,
    String? title,
    CustomHtml? content,
    String? author,
    String? updateDate,
    int? like,
    int? words,
    int? prevChapterId,
    int? nextChapterId,
    bool? isLike,
    List<Comment>? comments,
  }) {
    return ChapterContent(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      updateDate: updateDate ?? this.updateDate,
      like: like ?? this.like,
      words: words ?? this.words,
      prevChapterId: prevChapterId ?? this.prevChapterId,
      nextChapterId: nextChapterId ?? this.nextChapterId,
      isLike: isLike ?? this.isLike,
      comments: comments ?? this.comments,
    );
  }
}