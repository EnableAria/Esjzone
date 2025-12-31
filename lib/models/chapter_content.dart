import 'package:flutter/material.dart';
import '../models/comment.dart';

class ChapterContent {
  ChapterContent({
    required this.id,
    required this.title,
    required this.contents,
    required this.author,
    required this.updateDate,
    required this.like,
    required this.words,
    this.prevChapterId,
    this.nextChapterId,
    required this.isLike,
    this.isEncrypted = false,
    this.comments,

  });
  final int id; // 章节id
  final String title; // 章节标题
  final List<Widget> contents; // 章节内容
  final String author; // 作者
  final String updateDate; // 更新日期
  final int like; // 点赞数
  final int words; // 字数
  final int? prevChapterId; // 上章id
  final int? nextChapterId; // 下章id

  // 与用户有关的信息
  final bool isLike; // 是否喜欢
  final bool isEncrypted; // 是否加密

  final List<Comment>? comments; // 评论

  ChapterContent copyWith({
    int? id,
    String? title,
    List<Widget>? contents,
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
      contents: contents ?? this.contents,
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