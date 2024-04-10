import 'package:flutter/material.dart';
import '../models/patient.dart';

class PatientDetailsProvider extends ChangeNotifier {
  Patient _patient = Patient(firstName: '', lastName: '', address: '', email: '', gender: '', dateOfBirth: '', contactNumber: '', doctor: '');
  bool _isLoading = false;

  Patient get patient => _patient;
  bool get isLoading => _isLoading;

  setPatientDetails(Patient patient){
    _patient = patient;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
