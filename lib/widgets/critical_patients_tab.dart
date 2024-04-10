import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/providers/patients_provider.dart';
import 'package:mapd722_mobile_web_development/widgets/patient_card.dart';
import 'package:provider/provider.dart';

class CriticalPatientsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PatientsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: Colors.blue,),
          );
        } else if (provider.error != null) {
          return Center(
            child: Text(provider.error!),
          );
        } else if (provider.criticalPatientList.isEmpty) {
          return Center(
            child: Text('No critical patients found.'),
          );
        } else {
          return ListView.builder(
            itemCount: provider.criticalPatientList.length,
            itemBuilder: (context, index) {
              return PatientCard(patient: provider.criticalPatientList[index]);
            },
          );
        }
      },
    );
  }
}
