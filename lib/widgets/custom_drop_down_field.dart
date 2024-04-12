import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/constants/constants.dart';

class CustomDropdownFormField extends StatefulWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String> onChanged;

  const CustomDropdownFormField({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.black, width: 0.65),
      ),
      child: DropdownButtonFormField<String>(
        value: widget.value,
        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
        onChanged: (newValue) {
          setState(() {
            widget.onChanged(newValue!);
            _isDropdownOpen = false; // Close the dropdown when an item is selected
          });
        },
        onTap: () {
          setState(() {
            _isDropdownOpen = true;
          });
        },
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.medical_services, color: Constants.primaryColor,),
                  const SizedBox(width: 10,),
                  Text(
                    item,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.medical_services, color: Constants.primaryColor),
        ),
        style: const TextStyle(color: Colors.black),
        selectedItemBuilder: (BuildContext context) {
          return widget.items.map<Widget>((String item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
