// critical_patients_tab.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/patient_card.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';

class CriticalPatientsTab extends StatefulWidget {
  @override
  _CriticalPatientsTabState createState() => _CriticalPatientsTabState();
}

class _CriticalPatientsTabState extends State<CriticalPatientsTab> {
  late Future<List<Patient>> _patients;

  @override
  void initState() {
    super.initState();
    _patients = fetchCriticalPatients();
  }

  Future<List<Patient>> fetchCriticalPatients() async {
    final response = await http
        .get(Uri.parse('http://medicare-rest-api.onrender.com/criticalPatients'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load critical patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Patient>>(
      future: _patients,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.white,),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No critical patients found.'),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return PatientCard(patient: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}
