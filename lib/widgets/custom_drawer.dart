import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/screens/home_screen.dart';
import 'package:mapd722_mobile_web_development/screens/patients_screen.dart';
import '../constants/constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Constants.primaryColor, // Using primary color
                  width: 2.0,
                ),
              ),
            ),
            child: Center(
              child: Image.asset(
                "assets/images/MediCare.png",
                height: 100,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Home',
              style: TextStyle(
                color: Constants.primaryColor, // Using primary color
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            title: const Text(
              "Patient's List",
              style: TextStyle(
                color: Constants.primaryColor, // Using primary color
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PatientsScreen()),
              );
            },
          ),

          // Add more ListTile widgets for additional menu items
        ],
      ),
    );
  }
}
