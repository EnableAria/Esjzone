import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../routes/image.dart';
import '../widgets/network_image.dart';

// 定制Html解析
class CustomHtml extends StatelessWidget {
  const CustomHtml({super.key, required this.data, this.defaultData = "", this.fontSize = 13.0});
  final String? data;
  final String defaultData;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data ?? defaultData,
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

            return HeroImagePage(child: CustomNetImage(src, fit: BoxFit.contain));
          },
        ),
        TagExtension(
          tagsToExtend: {"ruby"},
          builder: (context) {
            final baseText = context.element?.nodes[0].text;
            final rubyText = context.element?.querySelector("rt")?.text;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (rubyText != null) Text(
                    rubyText,
                    textScaler: TextScaler.linear(0.6),
                    style: TextStyle(fontSize: fontSize, height: 0.8),
                  ),
                  Text(
                    baseText ?? rubyText ?? "",
                    textScaler: TextScaler.linear(0.95),
                    style: TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}