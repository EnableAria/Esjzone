import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkText extends StatelessWidget {
  const LinkText({
    super.key,
    required this.text,
    this.url,
    this.style,
  });
  final String text;
  final String? url;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {if (url != null) launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication);},
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: text,
              style: style?.copyWith(
                color: Colors.blue,
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.top,
              child: Icon(Icons.open_in_new, size: style?.fontSize),
            ),
          ],
        ),
        strutStyle: StrutStyle(forceStrutHeight: true),
      ),
    );
  }
}