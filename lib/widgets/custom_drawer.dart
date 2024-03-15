import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/screens/home_screen.dart';
import 'package:mapd722_mobile_web_development/screens/patients_screen.dart';
import '../constants/constants.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Image.asset(
                "assets/images/MediCare.png",
                height: 100,
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Constants.primaryColor, // Using primary color
                  width: 2.0,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
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
            title: Text(
              "Patient's List",
              style: TextStyle(
                color: Constants.primaryColor, // Using primary color
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PatientsScreen()),
              );
            },
          ),

          // Add more ListTile widgets for additional menu items
        ],
      ),
    );
  }
}
