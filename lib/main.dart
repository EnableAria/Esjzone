import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart';
import '../common/global.dart';
import '../routes/main.dart';
import '../routes/login.dart';
import '../routes/about.dart';
import '../routes/search.dart';
import '../routes/reader.dart';
import '../routes/detail.dart';
import '../routes/settings.dart';
import '../states/profile_change_notifier.dart';

void main() {
  Global.init().then((e) => runApp(const EsjzoneApp()));
}

class EsjzoneApp extends StatelessWidget {
  const EsjzoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserCookieModel()), // 用户信息
        ChangeNotifierProvider(create: (_) => ReaderSettingsModel()), // 阅读设置
        ChangeNotifierProvider(create: (_) => ThemeModeModel()), // 主题模式
        ChangeNotifierProvider(create: (_) => ThemeColorModel()), // 主题颜色
        ChangeNotifierProvider(create: (_) => ShowNSFWModel()), // 成人内容
        ChangeNotifierProvider(create: (_) => VolumeKeyPagingModel()), // 音量键翻页
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'EsjZone',
          initialRoute: "/",
          routes: {
            "/": (context) => AppPage(),
            "settings": (context) => SettingsPage(),
            "about": (context) => AboutPage(),
            "search": (context) => SearchPage(),
            "detail": (context) {
              final int id = int.tryParse("${ModalRoute.of(context)!.settings.arguments}") ?? 0;
              return DetailPage(id: id);
            },
            "reader": (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, int>? ?? {};
              return ReaderPage(bookId: args["bookId"] ?? 0, chapterId: args["chapterId"] ?? 0);
            },
          },
          // 主题模式
          themeMode: Provider.of<ThemeModeModel>(context).themeMode == 0 ? ThemeMode.system
              : Provider.of<ThemeModeModel>(context, listen: false).themeMode == 1 ? ThemeMode.light : ThemeMode.dark,
          // 主题颜色
          theme: CustomTheme.fromSeedColor(seedColor: Global.themes[Provider.of<ThemeColorModel>(context).theme ?? 0]),
          // 夜间模式主题颜色
          darkTheme: CustomTheme.fromSeedColor(
            seedColor: Global.themes[Global.profile.theme ?? 0],
            brightness: Brightness.dark,
            darkMode: Provider.of<ThemeModeModel>(context, listen: false).themeMode == 3,
          ),
        );
      }),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider.of<UserCookieModel>(context).isLogin
        ? const MainPage() // 主路由页
        : LoginPage(); // 登录页
  }
}