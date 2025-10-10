import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class FavoriteResponse {

  const FavoriteResponse({
    required this.status,
    required this.msg,
    required this.favorite,
  });

  final int status;
  final String msg;
  final int favorite;

  factory FavoriteResponse.fromJson(Map<String,dynamic> json) => FavoriteResponse(
    status: json['status'] as int,
    msg: json['msg'].toString(),
    favorite: json['favorite'] as int
  );
  
  Map<String, dynamic> toJson() => {
    'status': status,
    'msg': msg,
    'favorite': favorite
  };

  FavoriteResponse clone() => FavoriteResponse(
    status: status,
    msg: msg,
    favorite: favorite
  );


  FavoriteResponse copyWith({
    int? status,
    String? msg,
    int? favorite
  }) => FavoriteResponse(
    status: status ?? this.status,
    msg: msg ?? this.msg,
    favorite: favorite ?? this.favorite,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is FavoriteResponse && status == other.status && msg == other.msg && favorite == other.favorite;

  @override
  int get hashCode => status.hashCode ^ msg.hashCode ^ favorite.hashCode;
}
