import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class ReaderSettings {

  const ReaderSettings({
    this.fontSize,
    this.convert,
    this.hiddenSpacing,
    this.autoLike,
  });

  final double? fontSize;
  final int? convert;
  final bool? hiddenSpacing;
  final bool? autoLike;

  factory ReaderSettings.fromJson(Map<String,dynamic> json) => ReaderSettings(
    fontSize: json['fontSize'] != null ? (json['fontSize'] as num).toDouble() : null,
    convert: json['convert'] != null ? json['convert'] as int : null,
    hiddenSpacing: json['hiddenSpacing'] != null ? json['hiddenSpacing'] as bool : null,
    autoLike: json['autoLike'] != null ? json['autoLike'] as bool : null
  );
  
  Map<String, dynamic> toJson() => {
    'fontSize': fontSize,
    'convert': convert,
    'hiddenSpacing': hiddenSpacing,
    'autoLike': autoLike
  };

  ReaderSettings clone() => ReaderSettings(
    fontSize: fontSize,
    convert: convert,
    hiddenSpacing: hiddenSpacing,
    autoLike: autoLike
  );


  ReaderSettings copyWith({
    Optional<double?>? fontSize,
    Optional<int?>? convert,
    Optional<bool?>? hiddenSpacing,
    Optional<bool?>? autoLike
  }) => ReaderSettings(
    fontSize: checkOptional(fontSize, () => this.fontSize),
    convert: checkOptional(convert, () => this.convert),
    hiddenSpacing: checkOptional(hiddenSpacing, () => this.hiddenSpacing),
    autoLike: checkOptional(autoLike, () => this.autoLike),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is ReaderSettings && fontSize == other.fontSize && convert == other.convert && hiddenSpacing == other.hiddenSpacing && autoLike == other.autoLike;

  @override
  int get hashCode => fontSize.hashCode ^ convert.hashCode ^ hiddenSpacing.hashCode ^ autoLike.hashCode;
}
