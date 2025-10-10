import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/network_image.dart';

// 定制Html解析
class CustomHtml extends StatelessWidget {
  const CustomHtml({super.key, required this.data, this.fontSize = 13.0});
  final String? data;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      style: {
        "*": Style(
          fontSize: FontSize(fontSize),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          lineHeight: LineHeight(1.4), // 行高倍数，1.0为最小
        ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"img"},
          builder: (context) {
            final src = context.attributes['src'] ?? '';

            return CustomNetImage(
              src,
              fit: BoxFit.contain,
            );
          },
        ),
      ],
    );
  }
}