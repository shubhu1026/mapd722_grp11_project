import 'package:flutter/material.dart';
import '../constants/constants.dart';

class WhiteBGTextField extends StatefulWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;

  WhiteBGTextField({
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
  _WhiteBGTextFieldState createState() => _WhiteBGTextFieldState();
}

class _WhiteBGTextFieldState extends State<WhiteBGTextField> {
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
            labelStyle: TextStyle(
              color: _isFocused ? Colors.black : Colors.grey,
            ),
            prefixIcon: Icon(
              widget.prefixIcon,
              color: Constants.primaryColor,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
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
          onSaved: widget.onSaved,
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
          },
        ),
      ),
    );
  }
}
