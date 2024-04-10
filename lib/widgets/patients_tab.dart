import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/providers/patients_provider.dart';
import 'package:provider/provider.dart';
import 'package:mapd722_mobile_web_development/widgets/patient_card.dart';

class PatientsTab extends StatelessWidget {
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
          return ListView.builder(
            itemCount: provider.patientList.length,
            itemBuilder: (context, index) {
              return PatientCard(patient: provider.patientList[index]);
            },
          );
        }
      },
    );
  }
}
