import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged; // Added onChanged callback
  final void Function()? onEditingComplete;

  const CustomTextField({
    Key? key, // Added Key parameter
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.readOnly = false,
    this.onSaved,
    this.onChanged,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AbsorbPointer(
        absorbing: widget.readOnly,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: Icon(widget.prefixIcon, color: Constants.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          controller: widget.controller,
          obscureText: widget.isPassword,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter ${widget.labelText}';
            }
            return null;
          },
          onChanged: widget.onChanged,
          // Pass onChanged callback to TextFormField
          onSaved: widget.onSaved,
          onEditingComplete: widget.onEditingComplete,
          onTap: () {
            setState(() {
              _isFocused = true;
            });
            widget.onTap?.call();
          },
          onFieldSubmitted: (_) {
            setState(() {
              _isFocused = false;
            });
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
