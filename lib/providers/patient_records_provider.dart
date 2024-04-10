import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class PatientRecordsProvider extends ChangeNotifier {
  List<Record> _patientRecords = [];
  bool _isLoading = false;
  String? _error;

  List<Record> get patientRecords => _patientRecords;

  bool get isLoading => _isLoading;

  String? get error => _error;

  void setPatientRecords(List<Record> records) {
    _patientRecords = records;
    notifyListeners();
  }

  Future<void> fetchPatientRecords(String patientId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
          Uri.parse('${Constants.baseUrl}patients/$patientId/medicalTests'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _patientRecords = data.map((json) => Record.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load patient records';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePatientRecords(String patientId) async {
    fetchPatientRecords(patientId);
    notifyListeners();
  }
}
