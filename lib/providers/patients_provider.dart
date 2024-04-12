import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/constants/constants.dart';

class PatientsProvider extends ChangeNotifier {
  List<Patient> _patientList = [];
  List<Patient> _filteredList = [];
  bool _isLoading = false;
  String? _error;

  List<Patient> get patientList => _patientList;
  List<Patient> get filteredList => _filteredList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PatientsProvider() {
    _fetchPatients();
    _fetchCriticalPatients();
  }

  List<Patient> _criticalPatientList = [];
  List<Patient> _filteredCriticalList = [];

  List<Patient> get criticalPatientList => _criticalPatientList;
  List<Patient> get filteredCriticalList => _filteredCriticalList;

  Future<void> _fetchCriticalPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}criticalPatients'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _criticalPatientList = data.map((json) => Patient.fromJson(json)).toList();
        _filteredCriticalList = List.from(_criticalPatientList);
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
        _filteredList = List.from(_patientList);
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

  void searchPatients(String query) {
    if (query.isEmpty) {
      _filteredList = List.from(_patientList);
      notifyListeners();
      return;
    }

    _filteredList = _patientList.where((patient) {
      return patient.firstName.toLowerCase().contains(query.toLowerCase()) || patient.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    notifyListeners();
  }

  void searchCriticalPatients(String query) {
    if (query.isEmpty) {
      _filteredCriticalList = List.from(_criticalPatientList);
      notifyListeners();
      return;
    }

    _filteredCriticalList = _criticalPatientList.where((patient) {
      return patient.firstName.toLowerCase().contains(query.toLowerCase()) || patient.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    notifyListeners();
  }
}
