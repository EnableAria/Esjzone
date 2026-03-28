import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../states/profile_change_notifier.dart';
import '../../widgets/settings_item.dart';

// 设置路由页
class ReaderSettings extends StatelessWidget {
  const ReaderSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("阅读偏好")),
      body: ListView(
        children: [
          SettingGroup(title: "书籍详情"),
          SettingSwitch(
            title: "反转章节列表",
            subtitle: ["章节列表升序展示", "章节列表倒序展示"],
            initValue: Provider.of<ReadingPreferencesModel>(context, listen: false).readingPreferences.reverseChapterList ?? false,
            onChanged: (value) => Provider.of<ReadingPreferencesModel>(context, listen: false).update(reverseChapterList: value),
          ),
          SettingSwitch(
            title: "高亮更新章节",
            subtitle: ["正常展示章节", "淡化已读章节(根据最后阅读章节更新时间)"],
            initValue: Provider.of<ReadingPreferencesModel>(context, listen: false).readingPreferences.highlightUpdate ?? false,
            onChanged: (value) => Provider.of<ReadingPreferencesModel>(context, listen: false).update(highlightUpdate: value),
          ),
          SettingGroup(title: "阅读器"),
          SettingSwitch(
            // icon: (Provider.of<VolumeKeyPagingModel>(context).volumeKeyPaging ?? true)
            //     ? Icons.volume_off
            //     : Icons.volume_up,
            title: "音量键翻页",
            subtitle: ["阅读页音量键调整音量", "阅读页音量键滚动内容"],
            initValue: Provider.of<ReadingPreferencesModel>(context, listen: false).readingPreferences.volumeKeyPaging ?? true,
            onChanged: (value) => Provider.of<ReadingPreferencesModel>(context, listen: false).update(volumeKeyPaging: value),
          ),
          SettingGroup(title: "其他"),
          SettingSwitch(
            // icon: Icons.eighteen_up_rating,
            title: "成人内容",
            subtitle: ["首页不展示成人内容", "首页展示成人内容"],
            initValue: Provider.of<ReadingPreferencesModel>(context, listen: false).readingPreferences.showNSFW ?? true,
            onChanged: (value) => Provider.of<ReadingPreferencesModel>(context, listen: false).update(showNSFW: value),
          ),
        ],
      ),
    );
  }
}