import 'package:flutter/material.dart';

class CusTomInputDecoration  {
  final String labelText;

CusTomInputDecoration(this.labelText);
  InputDecoration getInputDecoration() {
    return InputDecoration(
      fillColor: Colors.grey.shade200,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), // Set the border radius
        borderSide: BorderSide.none, // This will remove the border color
      ),
      labelText: labelText,
    );
  }
}
