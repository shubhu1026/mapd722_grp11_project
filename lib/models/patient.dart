// patient.dart
import 'package:mapd722_mobile_web_development/models/record.dart';

class Patient {
  String? id;
  String firstName;
  String lastName;
  String address;
  String email;
  String gender;
  String dateOfBirth;
  String contactNumber;
  List<Record> recordHistory;
  String doctor;

  Patient({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.contactNumber,
    required this.recordHistory,
    required this.doctor,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      address: json['address'],
      email: json['email'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      contactNumber: json['contactNumber'],
      recordHistory: (json['recordHistory'] as List<dynamic>)
          .map((recordData) => Record.fromJson(recordData))
          .toList(),
      doctor: json['doctor'],
    );
  }
}
