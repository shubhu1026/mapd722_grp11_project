import 'package:flutter/material.dart';
import '../constants/constants.dart';

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
  Size get preferredSize => const Size.fromHeight(70.0);
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        backgroundColor: Constants.primaryColor,
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
                if (onMenu != null) {
                  onMenu!();
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
            ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
