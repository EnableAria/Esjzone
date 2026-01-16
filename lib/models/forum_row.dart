import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class ForumRow {

  const ForumRow({
    required this.subject,
    required this.cdate,
    required this.vtimes,
    required this.lastReply,
  });

  final String subject;
  final String cdate;
  final String vtimes;
  final String lastReply;

  factory ForumRow.fromJson(Map<String,dynamic> json) => ForumRow(
    subject: json['subject'].toString(),
    cdate: json['cdate'].toString(),
    vtimes: json['vtimes'].toString(),
    lastReply: json['last_reply'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'subject': subject,
    'cdate': cdate,
    'vtimes': vtimes,
    'last_reply': lastReply
  };

  ForumRow clone() => ForumRow(
    subject: subject,
    cdate: cdate,
    vtimes: vtimes,
    lastReply: lastReply
  );


  ForumRow copyWith({
    String? subject,
    String? cdate,
    String? vtimes,
    String? lastReply
  }) => ForumRow(
    subject: subject ?? this.subject,
    cdate: cdate ?? this.cdate,
    vtimes: vtimes ?? this.vtimes,
    lastReply: lastReply ?? this.lastReply,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is ForumRow && subject == other.subject && cdate == other.cdate && vtimes == other.vtimes && lastReply == other.lastReply;

  @override
  int get hashCode => subject.hashCode ^ cdate.hashCode ^ vtimes.hashCode ^ lastReply.hashCode;
}
