import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import '../models/index.dart';
import '../common/global.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); // 保存 Profile 变更
    super.notifyListeners(); // 通知依赖的 Widget 更新
  }
}

// 用户信息
class UserCookieModel extends ProfileChangeNotifier {
  UserCookie? get userCookie => _profile.userCookie;

  bool get isLogin => userCookie != null; // 是否登录过

  set userCookie(UserCookie? userCookie) {
    if (userCookie?.ewsKey != _profile.userCookie?.ewsKey
        || userCookie?.ewsToken != _profile.userCookie?.ewsToken
    ) {
      Global.profile = _profile.copyWith(
        userCookie: Optional.fromNullable(userCookie),
      );
      notifyListeners();
    }
  }

  /// 手动更新
  void updateProfile() => notifyListeners();
}

// 阅读设置
class ReaderSettingsModel extends ProfileChangeNotifier {
  ReaderSettings get readerSettings => _profile.readerSettings
      ?? ReaderSettings(fontSize: 18.0, hiddenSpacing: false);

  set readerSettings(ReaderSettings? readerSettings) {
    if (readerSettings != _profile.readerSettings) {
      Global.profile = _profile.copyWith(
        readerSettings: Optional.fromNullable(readerSettings),
      );
      notifyListeners();
    }
  }

  void update({
    double? fontSize,
    bool? hiddenSpacing,
  }) {
    readerSettings = readerSettings.copyWith(
      fontSize: Optional.fromNullable(fontSize ?? readerSettings.fontSize),
      hiddenSpacing: Optional.fromNullable(hiddenSpacing ?? readerSettings.hiddenSpacing),
    );
  }
}

// 主题模式
class ThemeModeModel extends ProfileChangeNotifier {
  bool? get darkMode => _profile.darkMode;

  set darkMode(bool? darkMode) {
    if (darkMode != _profile.darkMode) {
      Global.profile = _profile.copyWith(
        darkMode: Optional.fromNullable(darkMode),
      );
      notifyListeners();
    }
  }
}

// 主题颜色
class ThemeColorModel extends ProfileChangeNotifier {
  int? get theme => _profile.theme;

  set theme(int? theme) {
    if (theme != _profile.theme) {
      Global.profile = _profile.copyWith(
        theme: Optional.fromNullable(theme),
      );
      notifyListeners();
    }
  }
}

// 成人内容
class ShowNSFWModel extends ProfileChangeNotifier {
  bool? get showNSFW => _profile.showNSFW;

  set showNSFW(bool? showNSFW) {
    if (showNSFW != _profile.showNSFW) {
      Global.profile = _profile.copyWith(
        showNSFW: Optional.fromNullable(showNSFW),
      );
      notifyListeners();
    }
  }
}

// 音量键翻页
class VolumeKeyPagingModel extends ProfileChangeNotifier {
  bool? get volumeKeyPaging => _profile.volumeKeyPaging;

  set volumeKeyPaging(bool? volumeKeyPaging) {
    if (volumeKeyPaging != _profile.volumeKeyPaging) {
      Global.profile = _profile.copyWith(
        volumeKeyPaging: Optional.fromNullable(volumeKeyPaging),
      );
      notifyListeners();
    }
  }
}