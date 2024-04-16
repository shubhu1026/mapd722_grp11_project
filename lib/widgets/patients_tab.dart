import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mapd722_mobile_web_development/providers/patients_provider.dart';
import 'package:mapd722_mobile_web_development/widgets/white_bg_text_field.dart';
import 'package:provider/provider.dart';
import 'package:mapd722_mobile_web_development/widgets/patient_card.dart';

import '../constants/constants.dart';
import '../screens/patients_screen.dart';
import 'critical_patient_card.dart';

class PatientsTab extends StatelessWidget {
  PatientsTab({super.key});

  final TextEditingController _searchController = TextEditingController();

  Future<void> _showDeleteAllDialogBox(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete all patients?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Constants.primaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteAllPatients(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
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
        Provider.of<PatientsProvider>(context, listen: false)
            .updatePatientLists();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Successful'),
              content: const Text('Patients deleted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 307) {
        final newUrl = response.headers['location'];
        final redirectedResponse = await http.delete(
          Uri.parse(newUrl!),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        if (redirectedResponse.statusCode == 200 ||
            redirectedResponse.statusCode == 201) {
          Provider.of<PatientsProvider>(context, listen: false)
              .updatePatientLists();
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
                        MaterialPageRoute(
                            builder: (context) => const PatientsScreen()),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientsProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: WhiteBGTextField(
                    labelText: 'Search by Name',
                    prefixIcon: Icons.search,
                    controller: _searchController,
                    onChanged: (value) {
                      Provider.of<PatientsProvider>(context, listen: false)
                          .searchPatients(value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Add spacing between text field and button
                SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      "Delete All",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      _showDeleteAllDialogBox(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey; // Disabled button color
                          }
                          return Colors.white; // Enabled button color
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: provider.filteredList.isEmpty
                  ? const Center(child: Text('No patients found.'))
                  : ListView.builder(
                      itemCount: provider.filteredList.length,
                      itemBuilder: (context, index) {
                        final patient = provider.filteredList[index];
                        final isCritical = provider.criticalPatientList.any(
                          (criticalPatient) => criticalPatient.id == patient.id,
                        );

                        return isCritical
                            ? CriticalPatientCard(patient: patient)
                            : PatientCard(patient: patient);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
