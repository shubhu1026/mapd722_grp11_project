import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/providers/patients_provider.dart';
import 'package:mapd722_mobile_web_development/widgets/white_bg_text_field.dart';
import 'package:provider/provider.dart';

import 'critical_patient_card.dart';

class CriticalPatientsTab extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  CriticalPatientsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientsProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            WhiteBGTextField(
              labelText: 'Search by Name',
              prefixIcon: Icons.search,
              controller: _searchController,
              onChanged: (value) {
                Provider.of<PatientsProvider>(context, listen: false)
                    .searchCriticalPatients(value); // Change here to use searchCriticalPatients
              },
            ),
            const SizedBox(height: 10),
            if (provider.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.blue,),
                ),
              )
            else if (provider.error != null)
              Expanded(
                child: Center(
                  child: Text(provider.error!),
                ),
              )
            else if (provider.filteredCriticalList.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No critical patients found.'),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.filteredCriticalList.length, // Change here to use filteredCriticalList
                    itemBuilder: (context, index) {
                      return CriticalPatientCard(patient: provider.filteredCriticalList[index]); // Change here to use filteredCriticalList
                    },
                  ),
                ),
          ],
        );
      },
    );
  }
}
