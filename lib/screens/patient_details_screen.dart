import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/screens/edit_patient_details_screen.dart';

class PatientDetailsScreen extends StatefulWidget {
  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Patient Details',
        onBack: () {
          Navigator.pop(context);
        },
        onMenu: () {
          print('Custom menu button pressed!');
        },
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.9, // 80% of the screen width
              child: Card(
                color: Color(0xFF007CFF),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            iconSize: 24,
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPatientDetailsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 50.0,
                        child: Image.asset('assets/images/patient_icon.png'),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Patient Name',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Address:', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),),
                          SizedBox(width: 5,),
                          Text('30 Carabob Court', style: TextStyle(color: Colors.white, fontSize: 16),),
                        ],
                      ),
                      SizedBox(height: 2.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Date of Birth:', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),),
                          SizedBox(width: 5,),
                          Text('10/12/1996', style: TextStyle(color: Colors.white, fontSize: 16),),
                        ],
                      ),
                      SizedBox(height: 2.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Gender:', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),),
                          SizedBox(width: 5,),
                          Text('Male', style: TextStyle(color: Colors.white, fontSize: 16),),
                        ],
                      ),
                      SizedBox(height: 2.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Email:', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),),
                          SizedBox(width: 5,),
                          Text('test@gmail.com', style: TextStyle(color: Colors.white, fontSize: 16),),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality to view test records
                        },
                        child: Text('View Test Records', style: TextStyle(color: Color(0xFF007CFF)),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            iconSize: 24,
                            icon: Icon(Icons.delete_forever, color: Colors.white),
                            onPressed: () {
                              // Add functionality for delete button
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
