// Debug专用

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// 输出组件构建状态
class BuildTest extends StatelessWidget {
  const BuildTest({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    dPrint("build");
    return child;
  }
}

/// Debug模式下打印内容
void dPrint(Object? object) { if (kDebugMode) { print(object); }}