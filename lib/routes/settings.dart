import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/global.dart';
import '../states/profile_change_notifier.dart';
import '../widgets/settings_item.dart';

// 设置路由页
class SettingsRoute extends StatelessWidget {
  SettingsRoute({super.key});
  final Map<bool?, String> _themeMode = {
    null: "跟随系统",
    false: "日间模式",
    true: "夜间模式",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: ListView(
        children: [
          SettingTile(
            icon: Provider.of<ThemeModeModel>(context).darkMode == null
                ? Icons.brightness_auto
                : Provider.of<ThemeModeModel>(context, listen: false).darkMode!
                ? Icons.dark_mode
                : Icons.light_mode,
            title: "主题模式",
            subtitle: _themeMode[Provider.of<ThemeModeModel>(context, listen: false).darkMode],
            onTap: () { showThemeModeDialog(context: context); },
          ),
          SettingTile(
            icon:Icons.palette,
            title: "主题颜色",
            onTap: () { showThemeColorDialog(context: context); },
          ),
          SettingSwitch(
            icon: Icons.eighteen_up_rating,
            title: "成人内容",
            subtitle: ["不展示成人内容", "展示成人内容"],
            initValue: Provider.of<ShowNSFWModel>(context, listen: false).showNSFW ?? true,
            onChanged: (value) {
              Provider.of<ShowNSFWModel>(context, listen: false).showNSFW = value;
            },
          ),
        ],
      ),
    );
  }

  // 主题模式对话框
  Future<void> showThemeModeDialog({required BuildContext context}) async {
    await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: _themeMode.entries.map((e) {
            return SimpleDialogOption(
              onPressed: () {
                Provider.of<ThemeModeModel>(context, listen: false).darkMode = e.key;
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: Text(e.value)),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // 主题颜色对话框
  Future<void> showThemeColorDialog({required BuildContext context}) async {
    await showDialog<int?>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300.0,
            height: 300.0,
            padding: const EdgeInsets.all(20.0),
            child: GridView.count(
              crossAxisCount: 5,
              mainAxisSpacing: 6.0,
              crossAxisSpacing: 6.0,
              children: Global.themes.asMap().entries.map((e) => InkWell(
                onTap: () {
                  Provider.of<ThemeColorModel>(context, listen: false).theme = e.key;
                  Navigator.pop(context);
                },
                child: Container(
                  color: e.value,
                ),
              )).toList(),
            ),
          ),
        );
      },
    );
  }
}