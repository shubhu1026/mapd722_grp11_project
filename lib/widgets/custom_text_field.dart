import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;

  CustomTextField({
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: readOnly,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(prefixIcon, color: Color(0xFF007CFF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          readOnly: readOnly,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $labelText';
            }
            return null;
          },
        ),
      ),
    );
  }
}
