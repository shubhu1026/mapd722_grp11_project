import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/record_card.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:mapd722_mobile_web_development/widgets/white_bg_text_field.dart';
import '../constants/constants.dart';
import 'package:provider/provider.dart';
import '../providers/patient_records_provider.dart';

class RecordsTab extends StatefulWidget {
  final String? patientID;

  const RecordsTab({Key? key, required this.patientID}) : super(key: key);

  @override
  _RecordsTabState createState() => _RecordsTabState();
}

class _RecordsTabState extends State<RecordsTab> {

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PatientRecordsProvider>(context, listen: false);
    provider.fetchPatientRecords(widget.patientID!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientRecordsProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WhiteBGTextField(
                labelText: 'Search',
                prefixIcon: Icons.search,
                controller: _searchController,
                onChanged: (value) {
                  Provider.of<PatientRecordsProvider>(context, listen: false)
                      .searchRecords(value);
                },
              ),
            ),
            if (provider.isLoading) ...[
              Center(
                child: CircularProgressIndicator(color: Constants.primaryColor),
              ),
            ] else if (provider.error != null) ...[
              Center(
                child: Text('Error: ${provider.error}'),
              ),
            ] else if (provider.filteredRecords.isEmpty && _searchController.text.isNotEmpty) ...[
              // Check if isLoading is false and patientRecords is empty
              if (!provider.isLoading)
                Center(
                  child: Text('No records found.'),
                ),
            ] else ...[
              Expanded( // Wrap with Expanded to take up all available space
                child: RefreshIndicator(
                  onRefresh: () async {
                    provider.fetchPatientRecords(widget.patientID!);
                  },
                  child: ListView.builder(
                    itemCount: provider.filteredRecords.length,
                    itemBuilder: (context, index) {
                      return RecordCard(record: provider.filteredRecords[index], patientId: widget.patientID!);
                    },
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
