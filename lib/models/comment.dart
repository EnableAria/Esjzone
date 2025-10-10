import 'package:flutter/material.dart';

class Comment {
  Comment({
    required this.id,
    required this.number,
    required this.date,
    required this.commentator,
    required this.text,
    this.quote,
  });
  final int id; // 评论id
  final int number; // 评论编号
  final String date; // 评论日期
  final Commentator commentator; // 评论者
  final TextSpan text; // 评论文本
  final String? quote; // 引用文本(Esj的引用文本是单纯的文本，会丢失论坛表情)
}

class Commentator {
  Commentator({
    required this.id,
    required this.name,
    required this.profileSrc,
  });
  final int id; // 评论者id
  final String name; // 评论者昵称
  final String profileSrc; // 评论者头像
}