import 'package:flutter/material.dart';

class InputTextWithCallback extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final void Function(String)? onChanged; // Added onChanged parameter

  InputTextWithCallback({
    required this.label,
    required this.icon,
    required this.controller,
    this.onChanged, // Added this line
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      onChanged: onChanged, // Added this line
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
