import 'package:flutter/material.dart';
import '../widgets/network_image.dart';

// 大图路由页(Hero动画)
class HeroImagePage extends StatelessWidget {
  const HeroImagePage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          opaque: false, // 透明背景
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: Material(
                color: Colors.black.withValues(alpha: 0.8),
                child: InkWell(
                  onTap: () { Navigator.of(context).pop(); },
                  child: Center(
                    child: Hero(
                      tag: "HeroImage-${child.hashCode}",
                      child: child,
                    ),
                  ),
                ),
              ),
            );
          },
        ));
      },
      child: Hero(
        tag: "HeroImage-${child.hashCode}",
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: child,
        ),
      ),
    );
  }
}