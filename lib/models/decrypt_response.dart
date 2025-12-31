import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class DecryptResponse {

  const DecryptResponse({
    required this.status,
    required this.msg,
    required this.s,
    required this.url,
    required this.html,
    required this.text,
  });

  final int status;
  final String msg;
  final int s;
  final String url;
  final String html;
  final String text;

  factory DecryptResponse.fromJson(Map<String,dynamic> json) => DecryptResponse(
    status: json['status'] as int,
    msg: json['msg'].toString(),
    s: json['s'] as int,
    url: json['url'].toString(),
    html: json['html'].toString(),
    text: json['text'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'status': status,
    'msg': msg,
    's': s,
    'url': url,
    'html': html,
    'text': text
  };

  DecryptResponse clone() => DecryptResponse(
    status: status,
    msg: msg,
    s: s,
    url: url,
    html: html,
    text: text
  );


  DecryptResponse copyWith({
    int? status,
    String? msg,
    int? s,
    String? url,
    String? html,
    String? text
  }) => DecryptResponse(
    status: status ?? this.status,
    msg: msg ?? this.msg,
    s: s ?? this.s,
    url: url ?? this.url,
    html: html ?? this.html,
    text: text ?? this.text,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is DecryptResponse && status == other.status && msg == other.msg && s == other.s && url == other.url && html == other.html && text == other.text;

  @override
  int get hashCode => status.hashCode ^ msg.hashCode ^ s.hashCode ^ url.hashCode ^ html.hashCode ^ text.hashCode;
}
