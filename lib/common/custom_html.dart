import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../routes/image.dart';
import '../widgets/ruby_text.dart';
import '../widgets/network_image.dart';

// 定制Html解析
class CustomHtml extends StatelessWidget {
  const CustomHtml({
    super.key,
    required this.data,
    this.defaultData = "",
    this.fontSize = 13.0,
  });
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
        "br": Style(
          display: Display.none,
        ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"img"},
          builder: (context) {
            final src = context.attributes['src'] ?? '';
            return HeroImagePage(child: Center(child: CustomNetImage(src, fit: BoxFit.contain, cache: false)));
          },
        ),
        TagExtension(
          tagsToExtend: {"ruby"},
          builder: (context) {
            final baseText = context.element?.nodes[0].text ?? "";
            final rubyText = context.element?.querySelector("rt")?.text;

            return RubyText(
              text: baseText,
              ruby: rubyText ?? "",
              textStyle: context.style!.generateTextStyle(),
              rubyStyle: TextStyle(fontSize: fontSize * 0.6, height: 0.8),
            );
          },
        ),
        TagExtension(
          // 避免错误格式导致解析错误
          tagsToExtend: {"rt", "rp"},
          builder: (context) => SizedBox(),
        ),
      ],
    );
  }
}