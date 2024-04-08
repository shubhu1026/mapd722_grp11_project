import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_mobile_web_development/constants/constants.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';

class PatientsProvider with ChangeNotifier {
  late List<Patient> _patients;
  late List<Patient> _criticalPatients;
  Patient? _currentPatient;

  List<Patient> get patients => _patients;
  List<Patient> get criticalPatients => _criticalPatients;
  Patient? get currentPatient => _currentPatient;

  Future<void> fetchPatients() async {
    final response =
    await http.get(Uri.parse('${Constants.baseUrl}patients'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _patients = data.map((json) => Patient.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<void> fetchCriticalPatients() async {
    final response =
    await http.get(Uri.parse('${Constants.baseUrl}criticalPatients'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _criticalPatients = data.map((json) => Patient.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load critical patients');
    }
  }


  Future<void> fetchPatientDetails(String patientId) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}patients/$patientId'),
      );
      if (response.statusCode == 200) {
        _currentPatient = Patient.fromJson(json.decode(response.body));
        notifyListeners();
      } else {
        throw Exception('Failed to fetch patient details');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}patients/$patientId'),
      );
      if (response.statusCode == 307) {
        final newUrl = response.headers['location'];
        await http.delete(
          Uri.parse(newUrl!),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        // Remove patient from patients list
        _patients.removeWhere((patient) => patient.id == patientId);

        // Remove patient from critical patients list
        _criticalPatients.removeWhere((patient) => patient.id == patientId);

        notifyListeners();
      } else if (response.statusCode == 200) {
        // Patient deleted successfully without redirection
        // Remove patient from patients list
        _patients.removeWhere((patient) => patient.id == patientId);

        // Remove patient from critical patients list
        _criticalPatients.removeWhere((patient) => patient.id == patientId);

        notifyListeners();
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (error) {
      print('Error: $error');
      throw error; // Rethrow the error to handle it in the UI if needed
    }
  }

  Future<void> updatePatientDetails(Patient patient) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}patients/${patient.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(patient.toJson()),
      );
      if (response.statusCode == 307) {
        final newUrl = response.headers['location'];
        final redirectedResponse = await http.put(
          Uri.parse(newUrl!),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(patient.toJson()),
        );

        if (redirectedResponse.statusCode == 200) {
          await fetchPatients(); // Fetch updated patients list
          await fetchCriticalPatients(); // Fetch updated critical patients list
        } else {
          throw Exception('Failed to update patient details');
        }
      } else if (response.statusCode == 200) {
        await fetchPatients(); // Fetch updated patients list
        await fetchCriticalPatients(); // Fetch updated critical patients list
      } else {
        throw Exception('Failed to update patient details');
      }
    } catch (error) {
      print('Error: $error');
      throw error; // Rethrow the error to handle it in the UI if needed
    }
  }


  Future<void> addPatient(Patient patient) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}patients'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(patient.toJson()),
      );

      if (response.statusCode == 307) {
        final newUrl = response.headers['location'];
        final redirectedResponse = await http.post(
          Uri.parse(newUrl!),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(patient.toJson()),
        );

        if (redirectedResponse.statusCode == 201) {
          await fetchPatients(); // Fetch updated patients list
          await fetchCriticalPatients(); // Fetch updated critical patients list
        } else {
          throw Exception('Failed to add patient');
        }
      } else if (response.statusCode == 201) {
        await fetchPatients(); // Fetch updated patients list
        await fetchCriticalPatients(); // Fetch updated critical patients list
      } else {
        throw Exception('Failed to add patient');
      }
    } catch (error) {
      print('Error: $error');
      throw error; // Rethrow the error to handle it in the UI if needed
    }
  }

}
