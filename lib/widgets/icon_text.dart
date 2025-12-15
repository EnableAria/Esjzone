import 'package:flutter/material.dart';

// 图标文本
class IconText extends StatelessWidget {
  const IconText({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.size,
    this.flex = false,
    this.ellipsis = false,
    this.fittedText = false,
  });
  final IconData icon;
  final String text;
  final Color? color;
  final double? size;
  final bool flex;
  final bool ellipsis;
  final bool fittedText;

  @override
  Widget build(BuildContext context) {
    Widget child = Text(text,
      style: TextStyle(
        color: color,
        fontSize: size != null ? (size! - 4.0) : size,
      ),
      maxLines: flex ? null : 1,
      overflow: ellipsis ? TextOverflow.ellipsis : null,
    );
    if (flex || ellipsis || fittedText) {
      child = Expanded(
        child: fittedText
            ? FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: child,
        ) : child
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: size),
        SizedBox(width: 4.0),
        child,
      ],
    );
  }
}