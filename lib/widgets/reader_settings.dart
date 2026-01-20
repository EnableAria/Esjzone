import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/profile_change_notifier.dart';

// 阅读设置对话框组件
Future<void> showReaderSettings(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true, // 允许控制高度
    backgroundColor: Theme.of(context).canvasColor,
    builder: (context) {
      return Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          height: MediaQuery.of(context).size.height * 0.4,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              overscroll: false, // 禁用拉伸效果
            ),
            child: ListView(
              children: [
                _fontSizeSetting(),
                _textSwitch(
                  title: "隐藏换行",
                  initValue: Provider.of<ReaderSettingsModel>(context, listen: false).readerSettings.hiddenSpacing!,
                  onChanged: (value) => Provider.of<ReaderSettingsModel>(context, listen: false).update(hiddenSpacing: value),
                ),
                _textSwitch(
                  title: "自动点赞",
                  initValue: Provider.of<ReaderSettingsModel>(context, listen: false).readerSettings.autoLike!,
                  onChanged: (value) => Provider.of<ReaderSettingsModel>(context, listen: false).update(autoLike: value),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// 文本开关
Widget _textSwitch({
  required String title,
  required bool initValue,
  required void Function(bool) onChanged,
}){
  bool value = initValue;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title),
      StatefulBuilder(
        builder: (context, setState) {
          return Switch(
            value: value,
            onChanged: (v) {
              setState(() => value = v);
              onChanged(v);
            },
          );
        },
      )
    ],
  );
}

// 字体大小
Widget _fontSizeSetting() {
  return Row(
    children: [
      Expanded(child: Text("字体大小")),
      Expanded(child: StatefulBuilder(
        builder: (context, setState) {
          return Slider(
            min: 12,
            max: 24,
            divisions: 12,
            label: "${Provider.of<ReaderSettingsModel>(context).readerSettings.fontSize!.toInt()}",
            value: Provider.of<ReaderSettingsModel>(context).readerSettings.fontSize!,
            onChanged: (double value) {
              setState(() => Provider.of<ReaderSettingsModel>(context, listen: false).update(fontSize: value));
            },
          );
        },
      )),
    ],
  );
}