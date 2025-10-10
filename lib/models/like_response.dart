import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class LikeResponse {

  const LikeResponse({
    required this.status,
    required this.msg,
    required this.likes,
  });

  final int status;
  final String msg;
  final int likes;

  factory LikeResponse.fromJson(Map<String,dynamic> json) => LikeResponse(
    status: json['status'] as int,
    msg: json['msg'].toString(),
    likes: json['likes'] as int
  );
  
  Map<String, dynamic> toJson() => {
    'status': status,
    'msg': msg,
    'likes': likes
  };

  LikeResponse clone() => LikeResponse(
    status: status,
    msg: msg,
    likes: likes
  );


  LikeResponse copyWith({
    int? status,
    String? msg,
    int? likes
  }) => LikeResponse(
    status: status ?? this.status,
    msg: msg ?? this.msg,
    likes: likes ?? this.likes,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is LikeResponse && status == other.status && msg == other.msg && likes == other.likes;

  @override
  int get hashCode => status.hashCode ^ msg.hashCode ^ likes.hashCode;
}
