import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/constants/constants.dart';

class PatientsProvider extends ChangeNotifier {
  late Future<List<Patient>> _patients;
  List<Patient> _patientList = [];
  bool _isLoading = false;
  String? _error;

  List<Patient> get patientList => _patientList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PatientsProvider() {
    _fetchPatients();
    _fetchCriticalPatients();
  }

  late Future<List<Patient>> _criticalPatients;
  List<Patient> _criticalPatientList = [];

  List<Patient> get criticalPatientList => _criticalPatientList;

  Future<void> _fetchCriticalPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}criticalPatients'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _criticalPatientList = data.map((json) => Patient.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load critical patients';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}patients'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _patientList = data.map((json) => Patient.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load patients';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePatientLists() async {
    await _fetchPatients();
    await _fetchCriticalPatients();
    notifyListeners();
  }
}
