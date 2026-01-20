import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class Profile {

  const Profile({
    this.userCookie,
    this.readerSettings,
    this.theme,
    this.darkMode,
    this.showNSFW,
    this.volumeKeyPaging,
    this.locale,
    this.lastLogin,
  });

  final UserCookie? userCookie;
  final ReaderSettings? readerSettings;
  final int? theme;
  final bool? darkMode;
  final bool? showNSFW;
  final bool? volumeKeyPaging;
  final String? locale;
  final String? lastLogin;

  factory Profile.fromJson(Map<String,dynamic> json) => Profile(
    userCookie: json['userCookie'] != null ? UserCookie.fromJson(json['userCookie'] as Map<String, dynamic>) : null,
    readerSettings: json['readerSettings'] != null ? ReaderSettings.fromJson(json['readerSettings'] as Map<String, dynamic>) : null,
    theme: json['theme'] != null ? json['theme'] as int : null,
    darkMode: json['darkMode'] != null ? json['darkMode'] as bool : null,
    showNSFW: json['showNSFW'] != null ? json['showNSFW'] as bool : null,
    volumeKeyPaging: json['volumeKeyPaging'] != null ? json['volumeKeyPaging'] as bool : null,
    locale: json['locale']?.toString(),
    lastLogin: json['lastLogin']?.toString()
  );
  
  Map<String, dynamic> toJson() => {
    'userCookie': userCookie?.toJson(),
    'readerSettings': readerSettings?.toJson(),
    'theme': theme,
    'darkMode': darkMode,
    'showNSFW': showNSFW,
    'volumeKeyPaging': volumeKeyPaging,
    'locale': locale,
    'lastLogin': lastLogin
  };

  Profile clone() => Profile(
    userCookie: userCookie?.clone(),
    readerSettings: readerSettings?.clone(),
    theme: theme,
    darkMode: darkMode,
    showNSFW: showNSFW,
    volumeKeyPaging: volumeKeyPaging,
    locale: locale,
    lastLogin: lastLogin
  );


  Profile copyWith({
    Optional<UserCookie?>? userCookie,
    Optional<ReaderSettings?>? readerSettings,
    Optional<int?>? theme,
    Optional<bool?>? darkMode,
    Optional<bool?>? showNSFW,
    Optional<bool?>? volumeKeyPaging,
    Optional<String?>? locale,
    Optional<String?>? lastLogin
  }) => Profile(
    userCookie: checkOptional(userCookie, () => this.userCookie),
    readerSettings: checkOptional(readerSettings, () => this.readerSettings),
    theme: checkOptional(theme, () => this.theme),
    darkMode: checkOptional(darkMode, () => this.darkMode),
    showNSFW: checkOptional(showNSFW, () => this.showNSFW),
    volumeKeyPaging: checkOptional(volumeKeyPaging, () => this.volumeKeyPaging),
    locale: checkOptional(locale, () => this.locale),
    lastLogin: checkOptional(lastLogin, () => this.lastLogin),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is Profile && userCookie == other.userCookie && readerSettings == other.readerSettings && theme == other.theme && darkMode == other.darkMode && showNSFW == other.showNSFW && volumeKeyPaging == other.volumeKeyPaging && locale == other.locale && lastLogin == other.lastLogin;

  @override
  int get hashCode => userCookie.hashCode ^ readerSettings.hashCode ^ theme.hashCode ^ darkMode.hashCode ^ showNSFW.hashCode ^ volumeKeyPaging.hashCode ^ locale.hashCode ^ lastLogin.hashCode;
}
