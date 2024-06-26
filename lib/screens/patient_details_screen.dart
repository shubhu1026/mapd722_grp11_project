import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mapd722_mobile_web_development/screens/patients_screen.dart';
import 'package:mapd722_mobile_web_development/screens/test_records_screen.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/screens/edit_patient_details_screen.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/patient_details_provider.dart';
import '../providers/patients_provider.dart';
import '../util.dart';
import '../models/patient.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String? patientId;

  const PatientDetailsScreen({super.key, this.patientId});

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    Provider.of<PatientDetailsProvider>(context, listen: false).isLoading = true;
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}patients/${widget.patientId}'),
      );
      if (response.statusCode == 200) {
        final patient = Patient.fromJson(json.decode(response.body));
        Provider.of<PatientDetailsProvider>(context, listen: false)
            .setPatientDetails(patient);
        Provider.of<PatientDetailsProvider>(context, listen: false).isLoading = false;
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
              title: const Text('Delete Successful'),
              content: const Text('Patient deleted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PatientsScreen()),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        Provider.of<PatientsProvider>(context, listen: false).updatePatientLists();
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _showDeleteDialogBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this patient?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deletePatient();
               },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
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
      body: Consumer<PatientDetailsProvider>(
        builder: (context, provider, _) {
          final patient = provider.patient;
          return (provider.isLoading)
              ? const Center(
                  child:
                      CircularProgressIndicator(color: Constants.primaryColor))
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
                              vertical: 5.0,
                              horizontal: 5.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      iconSize: 24,
                                      icon:
                                          const Icon(Icons.edit, color: Colors.white),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditPatientDetailsScreen(
                                              patient: patient,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      iconSize: 24,
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        _showDeleteDialogBox();
                                      },
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 50.0,
                                  child: Image.asset(
                                      'assets/images/patient_icon.png'),
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  '${patient.firstName} ${patient.lastName}',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Address:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${patient.address}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Date of Birth:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      Util.getFormattedDate(
                                              DateTime.tryParse(
                                                  patient.dateOfBirth),
                                              DateFormat('dd MMM, yyyy')) ??
                                          '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Gender:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      patient.gender,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Email:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      patient.email,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TestRecordsScreen(
                                          patientID: widget.patientId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'View Test Records',
                                    style: TextStyle(
                                        color: Constants.primaryColor),
                                  ),
                                ),
                                const SizedBox(height: 6,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
