import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged; // Added onChanged callback

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.readOnly = false,
    this.onSaved,
    this.onChanged,
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
            prefixIcon: Icon(prefixIcon, color: Constants.primaryColor),
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
          onChanged: onChanged,
          // Pass onChanged callback to TextFormField
          onSaved: onSaved,
        ),
      ),
    );
  }
}
