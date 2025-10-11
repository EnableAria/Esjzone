import 'package:flutter/material.dart';

// 控件按钮(书籍详情)
class ControllerButton extends StatelessWidget {
  const ControllerButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.iconSize = 22.0,
    this.fontSize = 12.0,
    this.loading = false,
  });
  final IconData icon;
  final String text;
  final void Function()? onPressed;
  final double iconSize;
  final double fontSize;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: loading
          ? SizedBox.square(
        dimension: iconSize,
        child: CircularProgressIndicator(strokeWidth: 3.0))
          : Column(
        children: [
          Icon(icon, size: iconSize),
          Text(text, style: TextStyle(fontSize: fontSize)),
        ],
      ),
    );
  }
}