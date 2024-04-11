import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mapd722_mobile_web_development/providers/patients_provider.dart';
import 'package:provider/provider.dart';
import 'package:mapd722_mobile_web_development/widgets/patient_card.dart';

import '../constants/constants.dart';
import '../screens/patients_screen.dart';
import 'critical_patient_card.dart';

class PatientsTab extends StatelessWidget {
  Future<void> _showDeleteAllDialogBox(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete all patients?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteAllPatients(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllPatients(BuildContext context) async {
      try {
        final response = await http.delete(
          Uri.parse('${Constants.baseUrl}patients'),
        );
        if (response.statusCode == 201 || response.statusCode == 200) {
          Provider.of<PatientsProvider>(context, listen: false).updatePatientLists();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Delete Successful'),
                content: Text('Patient deleted successfully.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );

        }
        else if(response.statusCode == 307){
          final newUrl = response.headers['location'];
          final redirectedResponse = await http.delete(
            Uri.parse(newUrl!),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );

          if (redirectedResponse.statusCode == 200 || redirectedResponse.statusCode == 201){
            Provider.of<PatientsProvider>(context, listen: false).updatePatientLists();
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
          }
        }
          else {
          throw Exception('Failed to delete patient');
        }
      } catch (error) {
        print('Error: $error');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else if (provider.error != null) {
          return Center(
            child: Text(provider.error!),
          );
        } else if (provider.patientList.isEmpty) {
          return Center(
            child: Text('No patients found.'),
          );
        } else {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showDeleteAllDialogBox(context);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(width: 2,),
                          Text(
                            "Delete All Patients",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2,),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.patientList.length,
                  itemBuilder: (context, index) {
                    final patient = provider.patientList[index];
                    final isCritical = provider.criticalPatientList.any(
                        (criticalPatient) => criticalPatient.id == patient.id);

                    // Conditionally display critical patient card
                    if (isCritical) {
                      return CriticalPatientCard(patient: patient);
                    } else {
                      return PatientCard(patient: patient);
                    }
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
