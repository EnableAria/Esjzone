import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class Profile {

  const Profile({
    this.userCookie,
    this.theme,
    this.darkMode,
    this.showNSFW,
    this.locale,
    this.lastLogin,
  });

  final UserCookie? userCookie;
  final int? theme;
  final bool? darkMode;
  final bool? showNSFW;
  final String? locale;
  final String? lastLogin;

  factory Profile.fromJson(Map<String,dynamic> json) => Profile(
    userCookie: json['userCookie'] != null ? UserCookie.fromJson(json['userCookie'] as Map<String, dynamic>) : null,
    theme: json['theme'] != null ? json['theme'] as int : null,
    darkMode: json['darkMode'] != null ? json['darkMode'] as bool : null,
    showNSFW: json['showNSFW'] != null ? json['showNSFW'] as bool : null,
    locale: json['locale']?.toString(),
    lastLogin: json['lastLogin']?.toString()
  );
  
  Map<String, dynamic> toJson() => {
    'userCookie': userCookie?.toJson(),
    'theme': theme,
    'darkMode': darkMode,
    'showNSFW': showNSFW,
    'locale': locale,
    'lastLogin': lastLogin
  };

  Profile clone() => Profile(
    userCookie: userCookie?.clone(),
    theme: theme,
    darkMode: darkMode,
    showNSFW: showNSFW,
    locale: locale,
    lastLogin: lastLogin
  );


  Profile copyWith({
    Optional<UserCookie?>? userCookie,
    Optional<int?>? theme,
    Optional<bool?>? darkMode,
    Optional<bool?>? showNSFW,
    Optional<String?>? locale,
    Optional<String?>? lastLogin
  }) => Profile(
    userCookie: checkOptional(userCookie, () => this.userCookie),
    theme: checkOptional(theme, () => this.theme),
    darkMode: checkOptional(darkMode, () => this.darkMode),
    showNSFW: checkOptional(showNSFW, () => this.showNSFW),
    locale: checkOptional(locale, () => this.locale),
    lastLogin: checkOptional(lastLogin, () => this.lastLogin),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is Profile && userCookie == other.userCookie && theme == other.theme && darkMode == other.darkMode && showNSFW == other.showNSFW && locale == other.locale && lastLogin == other.lastLogin;

  @override
  int get hashCode => userCookie.hashCode ^ theme.hashCode ^ darkMode.hashCode ^ showNSFW.hashCode ^ locale.hashCode ^ lastLogin.hashCode;
}
