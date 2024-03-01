import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onBack;
  final Function? onMenu;

  CustomAppBar({
    required this.title,
    this.onBack,
    this.onMenu,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF007CFF),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      actions: [
        if (onMenu != null)
          IconButton(
            icon: Icon(Icons.menu_rounded),
            onPressed: () {
              onMenu!();
            },
          ),
      ],
      iconTheme: IconThemeData(color: Colors.white),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (onBack != null) {
            onBack!();
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
