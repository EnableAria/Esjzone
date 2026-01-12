import 'package:flutter/material.dart';
import '../common/text_measure.dart';

class RubyText extends StatelessWidget {
  const RubyText({
    super.key,
    required this.text,
    required this.ruby,
    required this.textStyle,
    required this.rubyStyle,
    this.spacing = 2,
  });

  final String text;
  final String ruby;
  final TextStyle textStyle;
  final TextStyle rubyStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final baseWidth = measureTextWidth(text, textStyle);
    final rubyWidth = measureTextWidth(ruby, rubyStyle);
    final targetWidth = baseWidth > rubyWidth ? baseWidth : rubyWidth;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        (rubyWidth == targetWidth || ruby.length <= 1)
            ? Text(ruby, style: rubyStyle)
            : _buildJustifiedText(
          text: ruby,
          style: rubyStyle,
          targetWidth: targetWidth,
        ),
        SizedBox(height: spacing),
        (baseWidth == targetWidth || text.length <= 1)
            ? Text(text, style: textStyle)
            : _buildJustifiedText(
          text: text,
          style: textStyle,
          targetWidth: targetWidth,
        ),
      ],
    );
  }

  // 字符均分文本组件
  Widget _buildJustifiedText({
    required String text,
    required TextStyle style,
    required double targetWidth,
  }) {
    return SizedBox(
      width: targetWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: text.characters.map((e) => Text(e, style: style)).toList(),
      ),
    );
  }
}