import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/network.dart';
import '../common/debug_tools.dart';
import '../models/profile.dart';

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
  static late SharedPreferences _prefs;
  static Profile profile = Profile();

  static List<Color> get themes => _themes;

  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // 初始化全局信息
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var profileForFile = _prefs.getString("profile");
    if (profileForFile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(profileForFile));
      }
      catch (e) { dPrint(e); }
    }
    else {
      profile = Profile(theme: 0, showNSFW: true);
    }

    // 初始化网络请求相关配置
    Esjzone.init();
  }

  // 持久化 Profile 信息
  static Future<bool> saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));
}