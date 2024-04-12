import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/constants/constants.dart';

class PatientsProvider extends ChangeNotifier {
  late Future<List<Patient>> _patients;
  List<Patient> _patientList = [];
  List<Patient> _filteredList = []; // New filtered list
  bool _isLoading = false;
  String? _error;

  List<Patient> get patientList => _patientList;
  List<Patient> get filteredList => _filteredList; // Getter for filtered list
  bool get isLoading => _isLoading;
  String? get error => _error;

  PatientsProvider() {
    _fetchPatients();
    _fetchCriticalPatients();
  }

  late Future<List<Patient>> _criticalPatients;
  List<Patient> _criticalPatientList = [];
  List<Patient> _filteredCriticalList = []; // New filtered list for critical patients

  List<Patient> get criticalPatientList => _criticalPatientList;
  List<Patient> get filteredCriticalList => _filteredCriticalList; // Getter for filtered critical list

  Future<void> _fetchCriticalPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}criticalPatients'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _criticalPatientList = data.map((json) => Patient.fromJson(json)).toList();
        _filteredCriticalList = List.from(_criticalPatientList); // Initialize filtered critical list
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
        _filteredList = List.from(_patientList); // Initialize filtered list
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
      _filteredList = List.from(_patientList); // Reset filtered list
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
      _filteredCriticalList = List.from(_criticalPatientList); // Reset filtered critical list
      notifyListeners();
      return;
    }

    _filteredCriticalList = _criticalPatientList.where((patient) {
      return patient.firstName.toLowerCase().contains(query.toLowerCase()) || patient.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    notifyListeners();
  }
}
