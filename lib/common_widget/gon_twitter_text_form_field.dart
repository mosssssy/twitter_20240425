import 'package:flutter/material.dart';

class GonTwitterTextFormField extends StatelessWidget {
  const GonTwitterTextFormField({
    super.key,
    required this.trimMsg,
    required this.controller,
    required this.maxLines,
    required this.readOnlyBool,
    required this.label,
  });

  final String trimMsg;
  final TextEditingController controller;
  final int maxLines;
  final bool readOnlyBool;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value == '') {
          return '未入力です';
        } else if (value.trim().isEmpty) {
          return trimMsg;
        }
        return null;
      },
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnlyBool,
      decoration: InputDecoration(
        label: Text(label),
      ),
    );
  }
}

class GonTwitterLimitedTextFormField extends StatelessWidget {
  const GonTwitterLimitedTextFormField({
    super.key,
    required this.trimMsg,
    required this.controller,
    required this.maxLength,
    required this.maxLines,
    required this.label,
  });

  final String trimMsg;
  final TextEditingController controller;
  final int maxLength;
  final int maxLines;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value == '') {
          return '未入力です';
        } else if (value.trim().isEmpty) {
          return trimMsg;
        }
        return null;
      },
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        label: Text(label),
      ),
    );
  }
}
