import 'package:flutter/material.dart';

// 提示按钮组件(仿FloatingActionButton)
class TooltipButton extends StatelessWidget {
  const TooltipButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    required this.child,
  });
  final String tooltip;
  final void Function()? onPressed;
  final Widget child;


  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 6, // 阴影高度
          iconSize: 24.0,
          minimumSize: Size(56, 56), // 最小尺寸
          padding: EdgeInsets.all(16), // 内边距
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          shadowColor: Theme.of(context).shadowColor, // 阴影颜色
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}