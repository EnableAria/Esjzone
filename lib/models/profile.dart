import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class Profile {

  const Profile({
    this.userCookie,
    this.readerSettings,
    this.readingPreferences,
    this.theme,
    this.themeMode,
    this.locale,
    this.lastLogin,
  });

  final UserCookie? userCookie;
  final ReaderSettings? readerSettings;
  final ReadingPreferences? readingPreferences;
  final int? theme;
  final int? themeMode;
  final String? locale;
  final String? lastLogin;

  factory Profile.fromJson(Map<String,dynamic> json) => Profile(
    userCookie: json['userCookie'] != null ? UserCookie.fromJson(json['userCookie'] as Map<String, dynamic>) : null,
    readerSettings: json['readerSettings'] != null ? ReaderSettings.fromJson(json['readerSettings'] as Map<String, dynamic>) : null,
    readingPreferences: json['readingPreferences'] != null ? ReadingPreferences.fromJson(json['readingPreferences'] as Map<String, dynamic>) : null,
    theme: json['theme'] != null ? json['theme'] as int : null,
    themeMode: json['themeMode'] != null ? json['themeMode'] as int : null,
    locale: json['locale']?.toString(),
    lastLogin: json['lastLogin']?.toString()
  );
  
  Map<String, dynamic> toJson() => {
    'userCookie': userCookie?.toJson(),
    'readerSettings': readerSettings?.toJson(),
    'readingPreferences': readingPreferences?.toJson(),
    'theme': theme,
    'themeMode': themeMode,
    'locale': locale,
    'lastLogin': lastLogin
  };

  Profile clone() => Profile(
    userCookie: userCookie?.clone(),
    readerSettings: readerSettings?.clone(),
    readingPreferences: readingPreferences?.clone(),
    theme: theme,
    themeMode: themeMode,
    locale: locale,
    lastLogin: lastLogin
  );


  Profile copyWith({
    Optional<UserCookie?>? userCookie,
    Optional<ReaderSettings?>? readerSettings,
    Optional<ReadingPreferences?>? readingPreferences,
    Optional<int?>? theme,
    Optional<int?>? themeMode,
    Optional<String?>? locale,
    Optional<String?>? lastLogin
  }) => Profile(
    userCookie: checkOptional(userCookie, () => this.userCookie),
    readerSettings: checkOptional(readerSettings, () => this.readerSettings),
    readingPreferences: checkOptional(readingPreferences, () => this.readingPreferences),
    theme: checkOptional(theme, () => this.theme),
    themeMode: checkOptional(themeMode, () => this.themeMode),
    locale: checkOptional(locale, () => this.locale),
    lastLogin: checkOptional(lastLogin, () => this.lastLogin),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is Profile && userCookie == other.userCookie && readerSettings == other.readerSettings && readingPreferences == other.readingPreferences && theme == other.theme && themeMode == other.themeMode && locale == other.locale && lastLogin == other.lastLogin;

  @override
  int get hashCode => userCookie.hashCode ^ readerSettings.hashCode ^ readingPreferences.hashCode ^ theme.hashCode ^ themeMode.hashCode ^ locale.hashCode ^ lastLogin.hashCode;
}
