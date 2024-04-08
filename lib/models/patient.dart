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
  List<Record>? recordHistory;
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
    this.recordHistory,
    required this.doctor,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'contactNumber': contactNumber,
      'recordHistory': recordHistory != null
          ? recordHistory!.map((record) => record.toJson()).toList()
          : null,
      'doctor': doctor,
    };
  }

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
      recordHistory: (json['recordHistory'] as List<dynamic>?)
          ?.map((recordData) => Record.fromJson(recordData))
          .toList(),
      doctor: json['doctor'],
    );
  }
}
