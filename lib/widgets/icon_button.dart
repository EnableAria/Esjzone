import 'package:flutter/material.dart';

// 图标按钮
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size,
    this.iconSize = 24.0,
    this.enableBackground = false,
    this.isLoading = false,
    this.superscript,
  });
  final IconData icon;
  final void Function()? onPressed;
  final double iconSize; // 图标大小
  final String? tooltip; // 提示
  final Size? size; // 按钮大小
  final bool enableBackground; // 启用背景
  final bool isLoading; // 显示加载条
  final int? superscript; // 数字角标

  @override
  Widget build(BuildContext context) {
    Widget button = IconButton(
      style: IconButton.styleFrom(
        shape: CircleBorder(),
        minimumSize: size,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: enableBackground
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
        disabledBackgroundColor: enableBackground
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
        iconSize: iconSize,
      ),
      icon: !isLoading ? Icon(icon)
          : SizedBox.square(
        dimension: iconSize,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onSurface,
          strokeWidth: 3.0,
        ),
      ),
      tooltip: tooltip,
      onPressed: onPressed,
    );
    return superscript == null ? button
        : Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          button,
          IgnorePointer(
            child: Container(
              margin: const EdgeInsets.all(2.0),
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                shape: StadiumBorder(),
              ),
              child: Text(
                "$superscript",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}