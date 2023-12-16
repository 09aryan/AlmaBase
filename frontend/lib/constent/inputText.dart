import 'package:flutter/material.dart';

class inputTextt extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  inputTextt({
    required this.label,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }
}
