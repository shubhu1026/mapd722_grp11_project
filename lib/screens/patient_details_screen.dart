import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mapd722_mobile_web_development/screens/patients_screen.dart';
import 'package:mapd722_mobile_web_development/screens/test_records_screen.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/screens/edit_patient_details_screen.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_drawer.dart';
import '../constants/constants.dart';
import '../util.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String? patientId;

  const PatientDetailsScreen({Key? key, this.patientId}) : super(key: key);

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Map<String, dynamic> _patientDetails = {};

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}patients/${widget.patientId}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _patientDetails = json.decode(response.body);
          print('hello : $_patientDetails');
        });
      } else {
        throw Exception('Failed to fetch patient details');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _deletePatient() async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}patients/${widget.patientId}'),
      );
      if (response.statusCode == 307) {
          final newUrl = response.headers['location'];
          final redirectedResponse = await http.delete(
            Uri.parse(newUrl!),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Successful'),
              content: Text('Patient deleted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PatientsScreen()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Patient Details',
        onBack: () {
          Navigator.pop(context);
        },
        onMenu: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      drawer: CustomDrawer(),
      body: _patientDetails.isEmpty
          ? Center(child: CircularProgressIndicator(color: Constants.primaryColor))
          : Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Card(
                    color: Constants.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
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
                                  print('Patient Details: $_patientDetails');
                                   Navigator.push(context,MaterialPageRoute(
                                    builder: (context) => EditPatientDetailsScreen(patientDetails: _patientDetails)),);
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
                            '${_patientDetails['firstName'] + " " + _patientDetails['lastName']}',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Address:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${_patientDetails['address'] ?? ''}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Date of Birth:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                Util.getFormattedDate(
                                    DateTime.tryParse(_patientDetails['dateOfBirth'] ?? ''),
                                    // Parse createdAt string to DateTime
                                    DateFormat('dd MMM, yyyy')) ?? '',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Gender:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${_patientDetails['gender'] ?? ''}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Email:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${_patientDetails['email'] ?? ''}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TestRecordsScreen(patientID: widget.patientId,),
                                ),
                              );
                            },
                            child: Text('View Test Records',
                                style: TextStyle(color: Constants.primaryColor)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                iconSize: 24,
                                icon:
                                Icon(Icons.delete_forever, color: Colors.white),
                                onPressed: () {
                                   _deletePatient();
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
