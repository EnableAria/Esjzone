import 'package:flutter/material.dart';

// 图标按钮(标题栏和工具菜单)
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.tooltip,
    this.size,
    this.iconSize = 24.0,
    this.enableBackground = false,
    this.isLoading = false,
    this.isSquare = false,
    this.superscript,
  });
  CustomIconButton.icon({
    super.key,
    required IconData icon,
    required this.onPressed,
    this.tooltip,
    this.size,
    this.iconSize = 24.0,
    this.enableBackground = false,
    this.isLoading = false,
    this.superscript,
  }) : child = Icon(icon), isSquare = true;
  final Widget child;
  final void Function()? onPressed;
  final double iconSize; // 图标大小
  final String? tooltip; // 提示
  final Size? size; // 按钮大小
  final bool enableBackground; // 启用背景
  final bool isLoading; // 显示加载条
  final int? superscript; // 数字角标
  final bool isSquare; // 方形约束

  @override
  Widget build(BuildContext context) {
    Widget button = IconButton(
      style: IconButton.styleFrom(
        shape: isSquare
            ? CircleBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
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
      icon: isLoading
          ? SizedBox.square(
        dimension: iconSize,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onSurface,
          strokeWidth: 3.0,
        ),
      )
      : isSquare
          ? SizedBox.square(dimension: iconSize, child: child)
          : child,
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
                  fontSize: iconSize / 2,
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

// 设置按钮
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

// 提示按钮(仿FloatingActionButton)(书籍详情浮动按钮)
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

/// 筛选列表项配置类
class Options<T extends Enum> {
  const Options ({
    required this.title,
    required this.options,
    required this.initialValue,
  });
  final String title;
  final List<T> options;
  final T initialValue;
}

/// 筛选按钮(图标)
class FilterIconButton extends StatefulWidget {
  FilterIconButton({
    super.key,
    this.onChanged,
    this.primaryOptions,
    this.primaryDelegate,
    this.secondaryOptions,
    this.secondaryDelegate,
  }) : assert(_validateVariables(primaryOptions, primaryDelegate)),
        assert(_validateVariables(secondaryOptions, secondaryDelegate)),
        assert(secondaryOptions == null || primaryOptions != null);
  final void Function(int, Enum?)? onChanged;
  final Options<Enum>? primaryOptions;
  final Widget Function(Enum)? primaryDelegate;
  final Options<Enum>? secondaryOptions;
  final Widget Function(Enum)? secondaryDelegate;

  /// 同时为空或不为空
  static bool _validateVariables(Object? a, Object? b) {
    final aIsNull = (a == null);
    final bIsNull = (b == null);
    return aIsNull == bIsNull;
  }

  @override
  State<FilterIconButton> createState() => FilterIconButtonState();
}

class FilterIconButtonState extends State<FilterIconButton> {
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      isSquare: true,
      onPressed: () {
        _showFilterDialog(
          context: context,
          options: [?widget.secondaryOptions, ?widget.primaryOptions],
        onChanged: widget.onChanged,
        );
      },
      child: Stack(
        children: [
          Icon(Icons.filter_alt),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(flex: 2, child: FittedBox(
                child: widget.secondaryDelegate != null
                    ? widget.secondaryDelegate!(widget.secondaryOptions!.initialValue)
                    : Container(),
              )),
              Expanded(child: Container()),
              Expanded(flex: 2, child: FittedBox(
                child: widget.primaryDelegate != null
                    ? widget.primaryDelegate!(widget.primaryOptions!.initialValue)
                    : Container(),
              )),
            ],
          ),
        ],
      ),
    );
  }
}