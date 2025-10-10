import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class LoginResponse {

  const LoginResponse({
    required this.status,
    required this.msg,
  });

  final int status;
  final String msg;

  factory LoginResponse.fromJson(Map<String,dynamic> json) => LoginResponse(
    status: json['status'] as int,
    msg: json['msg'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'status': status,
    'msg': msg
  };

  LoginResponse clone() => LoginResponse(
    status: status,
    msg: msg
  );


  LoginResponse copyWith({
    int? status,
    String? msg
  }) => LoginResponse(
    status: status ?? this.status,
    msg: msg ?? this.msg,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is LoginResponse && status == other.status && msg == other.msg;

  @override
  int get hashCode => status.hashCode ^ msg.hashCode;
}
