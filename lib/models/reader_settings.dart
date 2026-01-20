import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class ReaderSettings {

  const ReaderSettings({
    this.fontSize,
    this.hiddenSpacing,
    this.autoLike,
  });

  final double? fontSize;
  final bool? hiddenSpacing;
  final bool? autoLike;

  factory ReaderSettings.fromJson(Map<String,dynamic> json) => ReaderSettings(
    fontSize: json['fontSize'] != null ? (json['fontSize'] as num).toDouble() : null,
    hiddenSpacing: json['hiddenSpacing'] != null ? json['hiddenSpacing'] as bool : null,
    autoLike: json['autoLike'] != null ? json['autoLike'] as bool : null
  );
  
  Map<String, dynamic> toJson() => {
    'fontSize': fontSize,
    'hiddenSpacing': hiddenSpacing,
    'autoLike': autoLike
  };

  ReaderSettings clone() => ReaderSettings(
    fontSize: fontSize,
    hiddenSpacing: hiddenSpacing,
    autoLike: autoLike
  );


  ReaderSettings copyWith({
    Optional<double?>? fontSize,
    Optional<bool?>? hiddenSpacing,
    Optional<bool?>? autoLike
  }) => ReaderSettings(
    fontSize: checkOptional(fontSize, () => this.fontSize),
    hiddenSpacing: checkOptional(hiddenSpacing, () => this.hiddenSpacing),
    autoLike: checkOptional(autoLike, () => this.autoLike),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is ReaderSettings && fontSize == other.fontSize && hiddenSpacing == other.hiddenSpacing && autoLike == other.autoLike;

  @override
  int get hashCode => fontSize.hashCode ^ hiddenSpacing.hashCode ^ autoLike.hashCode;
}
