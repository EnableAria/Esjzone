import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
  });
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(icon, size: 28.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  if (subtitle != null) Text(subtitle!,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// 标题按钮设置项
class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final IconData? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SettingItem(
        title: title,
        subtitle: subtitle,
        icon: icon,
        action: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}

/// 单选开关设置项
class SettingSwitch extends StatefulWidget {
  const SettingSwitch({
    super.key,
    required this.title,
    required this.onChanged,
    this.icon,
    this.initValue,
    this.subtitle,
  });
  final String title;
  final IconData? icon;
  final List<String>? subtitle;
  final bool? initValue;
  final void Function(bool) onChanged;

  @override
  State<SettingSwitch> createState() => _SettingSwitchState();
}

class _SettingSwitchState extends State<SettingSwitch> {
  late bool _value;

  @override
  void initState() {
    _value = widget.initValue ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingItem(
      icon: widget.icon,
      title: widget.title,
      subtitle: (widget.subtitle != null && widget.subtitle!.length > 1)
          ? _value ? widget.subtitle![1] : widget.subtitle![0]
          : null,
      action: SizedBox(
        height: 40.0,
        child: FittedBox(
          child: Switch(
            value: _value,
            onChanged: (value) {
              setState(() { _value = value; });
              widget.onChanged(value);
            },
          ),
        ),
      ),
    );
  }
}