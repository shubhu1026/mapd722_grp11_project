import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/record_card.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
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
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: Constants.primaryColor),
          );
        } else if (provider.error != null) {
          return Center(
            child: Text('Error: ${provider.error}'),
          );
        } else if (provider.patientRecords.isEmpty) {
          return Center(
            child: Text('No records found.'),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              // Call the fetchPatientRecords method again
              provider.fetchPatientRecords(widget.patientID!);
            },
            child: ListView.builder(
              itemCount: provider.patientRecords.length,
              itemBuilder: (context, index) {
                return RecordCard(record: provider.patientRecords[index], patientId: widget.patientID!);
              },
            ),
          );
        }
      },
    );
  }
}
