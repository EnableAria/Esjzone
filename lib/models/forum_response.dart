import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class ForumResponse {

  const ForumResponse({
    required this.status,
    required this.total,
    required this.rows,
  });

  final int status;
  final int total;
  final List<ForumRow> rows;

  factory ForumResponse.fromJson(Map<String,dynamic> json) => ForumResponse(
    status: json['status'] as int,
    total: json['total'] as int,
    rows: (json['rows'] as List? ?? []).map((e) => ForumRow.fromJson(e as Map<String, dynamic>)).toList()
  );
  
  Map<String, dynamic> toJson() => {
    'status': status,
    'total': total,
    'rows': rows.map((e) => e.toJson()).toList()
  };

  ForumResponse clone() => ForumResponse(
    status: status,
    total: total,
    rows: rows.map((e) => e.clone()).toList()
  );


  ForumResponse copyWith({
    int? status,
    int? total,
    List<ForumRow>? rows
  }) => ForumResponse(
    status: status ?? this.status,
    total: total ?? this.total,
    rows: rows ?? this.rows,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is ForumResponse && status == other.status && total == other.total && rows == other.rows;

  @override
  int get hashCode => status.hashCode ^ total.hashCode ^ rows.hashCode;
}
