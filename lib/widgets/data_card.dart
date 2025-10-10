import 'package:flutter/material.dart';

abstract class DataCard<T> extends StatelessWidget {
  const DataCard({
    super.key,
    required this.data,
    this.useLine = false,
  });
  final T data;
  final bool useLine;

  Widget card();

  Widget line();

  @override
  Widget build(BuildContext context) {
    return useLine
        ? line()
        : card();
  }
}