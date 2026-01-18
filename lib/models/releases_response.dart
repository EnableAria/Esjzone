import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class ReleasesResponse {

  const ReleasesResponse({
    required this.tagName,
    required this.name,
    required this.htmlUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.body,
  });

  final String tagName;
  final String name;
  final String htmlUrl;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String body;

  factory ReleasesResponse.fromJson(Map<String,dynamic> json) => ReleasesResponse(
    tagName: json['tag_name'].toString(),
    name: json['name'].toString(),
    htmlUrl: json['html_url'].toString(),
    createdAt: json['created_at'].toString(),
    updatedAt: json['updated_at'].toString(),
    publishedAt: json['published_at'].toString(),
    body: json['body'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'tag_name': tagName,
    'name': name,
    'html_url': htmlUrl,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'published_at': publishedAt,
    'body': body
  };

  ReleasesResponse clone() => ReleasesResponse(
    tagName: tagName,
    name: name,
    htmlUrl: htmlUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
    publishedAt: publishedAt,
    body: body
  );


  ReleasesResponse copyWith({
    String? tagName,
    String? name,
    String? htmlUrl,
    String? createdAt,
    String? updatedAt,
    String? publishedAt,
    String? body
  }) => ReleasesResponse(
    tagName: tagName ?? this.tagName,
    name: name ?? this.name,
    htmlUrl: htmlUrl ?? this.htmlUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    publishedAt: publishedAt ?? this.publishedAt,
    body: body ?? this.body,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is ReleasesResponse && tagName == other.tagName && name == other.name && htmlUrl == other.htmlUrl && createdAt == other.createdAt && updatedAt == other.updatedAt && publishedAt == other.publishedAt && body == other.body;

  @override
  int get hashCode => tagName.hashCode ^ name.hashCode ^ htmlUrl.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ publishedAt.hashCode ^ body.hashCode;
}
