import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
import '../common/network.dart';
import '../common/pubspec.dart';
import '../common/debug_tools.dart';

const _themes = <Color>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.red
];

class Global {
  static late SharedPreferences _shared;
  static late String? _version;
  static Profile profile = Profile();
  static ReleasesResponse? latestReleases; // 最新发行版
  static List<Color> get themes => _themes; // 主题列表
  static String get version => _version ?? "unknown"; // 应用版本
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // 初始化全局信息
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    _shared = await SharedPreferences.getInstance();
    var profileForShared = _shared.getString("profile"); // 获取内部 Profile
    if (profileForShared != null) {
      try {
        Profile profileFromJson = Profile.fromJson(jsonDecode(profileForShared));
        // 部分初始化
        profile = profileFromJson.copyWith(
          theme: Optional.fromNullable(profileFromJson.theme ?? 0),
          showNSFW: Optional.fromNullable(profileFromJson.showNSFW ?? true),
          volumeKeyPaging: Optional.fromNullable(profileFromJson.volumeKeyPaging ?? true),
          readerSettings: Optional.fromNullable(
            (profileFromJson.readerSettings ?? ReaderSettings()).copyWith(
              fontSize: Optional.fromNullable(profileFromJson.readerSettings?.fontSize ?? 18.0),
              hiddenSpacing: Optional.fromNullable(profileFromJson.readerSettings?.hiddenSpacing ?? false),
              autoLike: Optional.fromNullable(profileFromJson.readerSettings?.autoLike ?? false),
            ),
          ),
        );
      }
      catch (e) { dPrint(e); }
    }
    else {
      // 完全初始化
      profile = Profile(
        theme: 0,
        showNSFW: true,
        volumeKeyPaging: true,
        readerSettings: ReaderSettings(
          fontSize: 18.0,
          hiddenSpacing: false,
          autoLike: false,
        ),
      );
    }
    saveProfile();

    Esjzone.init(); // 初始化网络请求相关配置
    _version = await getVersion(); // 获取应用版本
  }

  // 持久化 Profile 信息
  static Future<bool> saveProfile() => _shared.setString("profile", jsonEncode(profile.toJson()));
}