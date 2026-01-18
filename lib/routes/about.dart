import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/global.dart';
import '../common/compare.dart';
import '../common/network.dart';
import '../models/releases_response.dart';
import '../widgets/settings_item.dart';

const String repositoryUrl = "https://github.com/EnableAria/Esjzone"; // 仓库地址
const String websiteUrl = "https://www.esjzone.one"; // 网站主页

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  bool isVerLoading = false;

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
          wSettingTile(
            icon: Icons.tag,
            title: "当前版本",
            subtitle: Global.version,
            onTap: () async {
              if (!isVerLoading) {
                isVerLoading = true;
                if (Global.latestReleases == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("正在检查更新")),
                  );
                  ReleasesResponse? response = await Esjzone().checkUpdate();
                  if (response != null) { Global.latestReleases = response; }
                  else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("检查更新失败")),
                    );
                  }
                }
                if (context.mounted) {
                  if (Global.version.contains("+") && isNewVersion(Global.latestReleases!.tagName, Global.version)) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => wReleasesDialog(releases: Global.latestReleases!),
                    );
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(Global.version.contains("+") ? "已是最新版本" : "应用版本错误")),
                    );
                  }
                }
                isVerLoading = false;
              }
            },
          ),
          wSettingTile(
            icon: Icons.public,
            title: "项目地址",
            subtitle: repositoryUrl,
            onTap: () => launchUrl(Uri.parse(repositoryUrl), mode: LaunchMode.externalApplication),
          ),
          wSettingTile(
            icon: Icons.home,
            title: "网站主页",
            subtitle: websiteUrl,
            onTap: () => launchUrl(Uri.parse(websiteUrl), mode: LaunchMode.externalApplication),
          ),
        ],
      ),
    );
  }

  // 标题按钮封装
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

  // 对话框标题封装
  Widget wDialogHeader({
    required String version,
    required String date,
  }) {
    DateTime update = DateTime.parse(date);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(version, style: TextStyle(fontSize: 24)),
          Text(
            "${update.year}/${update.month}/${update.day}",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // 对话框按钮封装
  Widget wDialogButton({
    required void Function()? onPressed,
    required Widget child,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(), // 矩形形状
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  // 更新对话框封装
  Widget wReleasesDialog({required ReleasesResponse releases}) {
    return Dialog(
      child: Builder(builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          wDialogHeader(version: releases.tagName, date: releases.publishedAt),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(overscroll: false), // 禁用拉伸效果
              child: ListView(
                shrinkWrap: true,
                children: releases.body.split("\r\n").map((e) => Text(e)).toList(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(child: wDialogButton(
                  onPressed: () => launchUrl(Uri.parse(releases.htmlUrl), mode: LaunchMode.externalApplication),
                  child: Text("前往更新"),
                )),
                Expanded(child: wDialogButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("暂不更新"),
                )),
              ],
            ),
          ),
        ],
      )),
    );
  }
}