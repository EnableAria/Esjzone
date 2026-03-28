import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class ReadingPreferences {

  const ReadingPreferences({
    this.reverseChapterList,
    this.highlightUpdate,
    this.volumeKeyPaging,
    this.showNSFW,
  });

  final bool? reverseChapterList;
  final bool? highlightUpdate;
  final bool? volumeKeyPaging;
  final bool? showNSFW;

  factory ReadingPreferences.fromJson(Map<String,dynamic> json) => ReadingPreferences(
    reverseChapterList: json['reverse_chapter_list'] != null ? json['reverse_chapter_list'] as bool : null,
    highlightUpdate: json['highlight_update'] != null ? json['highlight_update'] as bool : null,
    volumeKeyPaging: json['volumeKeyPaging'] != null ? json['volumeKeyPaging'] as bool : null,
    showNSFW: json['showNSFW'] != null ? json['showNSFW'] as bool : null
  );
  
  Map<String, dynamic> toJson() => {
    'reverse_chapter_list': reverseChapterList,
    'highlight_update': highlightUpdate,
    'volumeKeyPaging': volumeKeyPaging,
    'showNSFW': showNSFW
  };

  ReadingPreferences clone() => ReadingPreferences(
    reverseChapterList: reverseChapterList,
    highlightUpdate: highlightUpdate,
    volumeKeyPaging: volumeKeyPaging,
    showNSFW: showNSFW
  );


  ReadingPreferences copyWith({
    Optional<bool?>? reverseChapterList,
    Optional<bool?>? highlightUpdate,
    Optional<bool?>? volumeKeyPaging,
    Optional<bool?>? showNSFW
  }) => ReadingPreferences(
    reverseChapterList: checkOptional(reverseChapterList, () => this.reverseChapterList),
    highlightUpdate: checkOptional(highlightUpdate, () => this.highlightUpdate),
    volumeKeyPaging: checkOptional(volumeKeyPaging, () => this.volumeKeyPaging),
    showNSFW: checkOptional(showNSFW, () => this.showNSFW),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is ReadingPreferences && reverseChapterList == other.reverseChapterList && highlightUpdate == other.highlightUpdate && volumeKeyPaging == other.volumeKeyPaging && showNSFW == other.showNSFW;

  @override
  int get hashCode => reverseChapterList.hashCode ^ highlightUpdate.hashCode ^ volumeKeyPaging.hashCode ^ showNSFW.hashCode;
}
