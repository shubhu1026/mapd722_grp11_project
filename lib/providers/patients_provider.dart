import 'package:flutter/foundation.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientsProvider with ChangeNotifier {
  List<Patient> _patients = [];
  List<Patient> _criticalPatients = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Patient> get patients => _patients;
  List<Patient> get criticalPatients => _criticalPatients;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty; // Define hasError getter

  Future<void> fetchPatients() async {
    try {
      _isLoading = true;
      final response = await http.get(
        Uri.parse('https://medicare-rest-api.onrender.com/patients'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        _patients = responseData.map((data) => Patient.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch patients');
      }
    } catch (error) {
      _errorMessage = 'Error fetching patients: $error';
      print(_errorMessage);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> fetchCriticalPatients() async {
    try {
      _isLoading = true;
      final response = await http.get(
        Uri.parse('https://medicare-rest-api.onrender.com/criticalPatients'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        _criticalPatients = responseData.map((data) => Patient.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch critical patients');
      }
    } catch (error) {
      _errorMessage = 'Error fetching critical patients: $error';
      print(_errorMessage);
    } finally {
      _isLoading = false;
    }
  }
}
