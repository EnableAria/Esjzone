import 'package:flutter/material.dart';

// 设置按钮组件
class SettingButton extends StatelessWidget {
  const SettingButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.iconSize = 28.0,
    this.fontSize = 16.0,
    this.alignment = Alignment.centerLeft,
    this.foregroundColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
  });
  final Icon icon;
  final String text;
  final void Function()? onPressed;
  final double iconSize;
  final double fontSize;
  final Alignment alignment;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: padding,
        iconSize: iconSize,
        textStyle: TextStyle(fontSize: fontSize),
        alignment: alignment,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
      ),
      icon: icon,
      label: Text(text),
      onPressed: onPressed,
    );
  }
}