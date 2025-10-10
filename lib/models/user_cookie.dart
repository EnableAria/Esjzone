import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class UserCookie {

  const UserCookie({
    required this.ewsKey,
    required this.ewsToken,
  });

  final String ewsKey;
  final String ewsToken;

  factory UserCookie.fromJson(Map<String,dynamic> json) => UserCookie(
    ewsKey: json['ews_key'].toString(),
    ewsToken: json['ews_token'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'ews_key': ewsKey,
    'ews_token': ewsToken
  };

  UserCookie clone() => UserCookie(
    ewsKey: ewsKey,
    ewsToken: ewsToken
  );


  UserCookie copyWith({
    String? ewsKey,
    String? ewsToken
  }) => UserCookie(
    ewsKey: ewsKey ?? this.ewsKey,
    ewsToken: ewsToken ?? this.ewsToken,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is UserCookie && ewsKey == other.ewsKey && ewsToken == other.ewsToken;

  @override
  int get hashCode => ewsKey.hashCode ^ ewsToken.hashCode;
}
