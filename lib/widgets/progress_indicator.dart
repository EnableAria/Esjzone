import 'dart:math' show pi;
import 'package:flutter/material.dart';

class StorageRing extends StatelessWidget {
  const StorageRing({
    required this.storage,
    required this.size,
    this.strokeWidth,
    super.key,
  });
  final String? storage;
  final double size;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final double strokeWidth = this.strokeWidth ?? size * 0.075;

    return Container(
      padding: EdgeInsets.all(strokeWidth * 0.5),
      width: size,
      height: size,
      child: Stack(children: [
        Transform.rotate(
          angle: pi * 1.25,
          child: Stack(children: [
            SizedBox.square(
              dimension: size,
              child: CircularProgressIndicator(
                value: 0.75,
                strokeWidth: strokeWidth,
                strokeCap: StrokeCap.round,
                color: Theme.of(context).colorScheme.surfaceDim,
              ),
            ),
            SizedBox.square(
              dimension: size,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: storage == null ? 0 : 0.75),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, _) => CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
          ]),
        ),
        Center(
          child: SizedBox(
            width: size * 0.75,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                storage ?? "正在获取...",
                style: TextStyle(fontSize: size * 0.2),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: size * 0.55,
            height: size * 0.15,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("封面缓存占用" ,textAlign: TextAlign.center),
            ),
          ),
        ),
      ]),
    );
  }
}