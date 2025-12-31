import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/settings_item.dart';

const String version = "1.0.5+17"; // 软件版本
const String repositoryUrl = "https://github.com/EnableAria/Esjzone"; // 仓库地址
const String websiteUrl = "https://www.esjzone.one"; // 网站主页

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于"),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: ListView(
        children: [
          Center(child: SizedBox.square(dimension: 200, child: Image.asset("assets/icon/icon_foreground.png"))),
          SettingItem(
            icon: Icons.tag,
            title: "当前版本",
            subtitle: version,
          ),
          wSettingTile(
            icon: Icons.public,
            title: "项目地址",
            subtitle: repositoryUrl,
            onTap: () {
              Clipboard.setData(ClipboardData(text: repositoryUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('链接已复制')),
              );
            },
          ),
          wSettingTile(
            icon: Icons.home,
            title: "网站主页",
            subtitle: websiteUrl,
            onTap: () {
              Clipboard.setData(ClipboardData(text: websiteUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('链接已复制')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget wSettingTile({
    required String title,
    required void Function()? onTap,
    IconData? icon,
    String? subtitle,
  }){
    return InkWell(
      onTap: onTap,
      child: SettingItem(
        title: title,
        subtitle: subtitle,
        icon: icon,
      ),
    );
  }
}