// 折叠可展开文本
// 用于 作品简介

import 'package:flutter/material.dart';
import '../common/custom_html.dart';

// 可展开文本域(书籍简介)
class ExpandableText extends StatefulWidget {
  const ExpandableText({super.key, required this.html});
  final CustomHtml html;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            maxHeight: isExpand ? double.infinity : 60.0,
          ),
          child: ClipRect(
            child: AnimatedSize(
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  SelectionArea(child: widget.html),
                  if (!isExpand) Align(
                    alignment: Alignment(0.0, 1.1),
                    child: wExpandButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpand) wExpandButton(),
      ],
    );
  }

  // 展开按钮控件
  Widget wExpandButton() {
    return GestureDetector(
      onTap: () => setState(() => isExpand = !isExpand),
      child: isExpand ? wMaskIcon(Icons.keyboard_arrow_up) : wMaskIcon(Icons.keyboard_arrow_down),
    );
  }

  // 展开按钮背景遮罩
  Widget wMaskIcon(IconData icon) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.0),
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Icon(icon),
    );
  }
}