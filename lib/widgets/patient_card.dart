// patient_card.dart
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/screens/patient_details_screen.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;

  const PatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailsScreen(),
          ),
        );
      },
      child: Card(
        //color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(child: Image.asset('assets/images/patient_icon.png'),),
          title: Text('${patient.firstName} ${patient.lastName}'),
          subtitle: Text('Date of Birth: ${patient.dateOfBirth}'),
          trailing:  IconButton(
            icon: const Icon(Icons.arrow_drop_down_circle_outlined),
            onPressed: () {
              // Add your back button functionality here
      
            },
          ),
        ),
      ),
    );
  }
}
