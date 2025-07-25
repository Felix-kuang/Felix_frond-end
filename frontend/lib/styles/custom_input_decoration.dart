import 'package:flutter/material.dart';

class CustomInputDecoration {
  static InputDecoration textField({
    required String label,
    bool isRequired = false,
    Widget? prefix,
  }) {
    return InputDecoration(
      labelText: isRequired ? "$label*" : label,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      prefix: prefix,
      errorStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
