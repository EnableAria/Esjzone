import 'package:flutter/material.dart';

// 下拉选框
class CustomDropdownMenu<T extends Enum> extends StatelessWidget {
  const CustomDropdownMenu({
    super.key,
    required this.initialValue,
    required this.values,
    this.onChanged,
  });
  final T initialValue;
  final List<T> values;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: DropdownButtonFormField<T>(
        initialValue: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        items: values.map((e) =>
            DropdownMenuItem<T>(
              value: e,
              child: Text((e as dynamic).description, style: TextStyle(fontSize: 14.0)),
            )
        ).toList(),
        onChanged: onChanged,
      ),
    );
  }
}