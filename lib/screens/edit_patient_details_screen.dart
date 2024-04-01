import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/screens/patient_details_screen.dart';
import 'package:mapd722_mobile_web_development/screens/patients_screen.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_drawer.dart';
import '../constants/constants.dart';

class EditPatientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? patientDetails;

  const EditPatientDetailsScreen({Key? key, this.patientDetails}) : super(key: key);

  @override
  _EditPatientDetailsScreenState createState() => _EditPatientDetailsScreenState();
}

enum Gender { Male, Female }

class _EditPatientDetailsScreenState extends State<EditPatientDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patient = Patient(
    id: '',
    firstName: '',
    lastName: '',
    address: '',
    email: '',
    gender: '',
    dateOfBirth: '',
    contactNumber: '',
    recordHistory: [],
    doctor: '',
  );

  Gender? _selectedGender;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _doctorController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check if patient details exist and set the text controllers
    if (widget.patientDetails != null) {
      _firstNameController.text = widget.patientDetails!['firstName'] ?? '';
      _lastNameController.text = widget.patientDetails!['lastName'] ?? '';
      _addressController.text = widget.patientDetails!['address'] ?? '';
      _dobController.text = widget.patientDetails!['dateOfBirth'] ?? '';
      _doctorController.text = widget.patientDetails!['doctor'] ?? '';
      _emailController.text = widget.patientDetails!['email'] ?? '';
      _phoneController.text = widget.patientDetails!['contactNumber'] ?? '';

      // Set the gender based on existing data
      if (widget.patientDetails!['gender'] == 'Male') {
        setState(() {
          _selectedGender = Gender.Male;
        });
      } else if (widget.patientDetails!['gender'] == 'Female') {
        setState(() {
          _selectedGender = Gender.Female;
        });
      }
      // Set the patient ID if available
      _patient.id = widget.patientDetails!['_id'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Edit Patient Details',
        onBack: () {
          Navigator.pop(context);
        },
        onMenu: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patient Details',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                Column(
                  children: [
                    CustomTextField(
                      labelText: 'First Name',
                      prefixIcon: Icons.person,
                      controller: _firstNameController,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Last Name',
                      prefixIcon: Icons.person,
                      controller: _lastNameController,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Address',
                      prefixIcon: Icons.pin_drop,
                      controller: _addressController,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Date of Birth',
                      prefixIcon: Icons.calendar_month,
                      controller: _dobController,
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Doctor\'s Name',
                      prefixIcon: Icons.medical_information,
                      controller: _doctorController,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Email',
                      prefixIcon: Icons.email,
                      controller: _emailController,
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 0.6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.person,
                                color: Constants.primaryColor,
                              ),
                            ),
                            Text('Gender:',
                                style: Theme.of(context).textTheme.subtitle1),
                            Radio(
                              value: Gender.Male,
                              groupValue: _selectedGender,
                              onChanged: (Gender? value) {
                                setState(() {
                                  _selectedGender = value;
                                  _patient.gender =
                                  'Male'; // Update the gender property
                                });
                              },
                              activeColor: Constants.primaryColor,
                            ),
                            Text('Male'),
                            Radio(
                              value: Gender.Female,
                              groupValue: _selectedGender,
                              onChanged: (Gender? value) {
                                setState(() {
                                  _selectedGender = value;
                                  _patient.gender =
                                  'Female'; // Update the gender property
                                });
                              },
                              activeColor: Constants.primaryColor,
                            ),
                            Text('Female'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Phone No.',
                      prefixIcon: Icons.phone,
                      controller: _phoneController,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Save Changes'.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Constants.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _patient.dateOfBirth) {
      _dobController.text = pickedDate.toLocal().toString().split(' ')[0];
      _patient.dateOfBirth = _dobController.text;
    }
  }

  void _submitForm() {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    _updatePatientDetails();
  }
  }
  Future<void> _updatePatientDetails() async {
  try {
        print('Updating patient details:');
    print('First Name: ${_patient.id}');
    print('Last Name: ${_lastNameController.text}');
    print('Address: ${_addressController.text}');
    print('Date of Birth: ${_dobController.text}');
    print('Doctor: ${_doctorController.text}');
    print('Email: ${_emailController.text}');
    print('Gender: ${_selectedGender.toString().split('.').last}');
    print('Contact Number: ${_phoneController.text}');
    final response = await http.put(
      
      Uri.parse('${Constants.baseUrl}patients/${_patient.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'address': _addressController.text,
        'dateOfBirth': _dobController.text,
        'doctor': _doctorController.text,
        'email': _emailController.text,
        'gender': _selectedGender.toString().split('.').last, // Convert enum to string
        'contactNumber': _phoneController.text,
      }),
    );
        if (response.statusCode == 307) {
          // Extract the new URL from the Location header
          final newUrl = response.headers['location'];
             print('Redirected response body:  ${newUrl}',);
          // Make another POST request to the new URL
          final redirectedResponse = await http.put(
            Uri.parse(newUrl!),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              'firstName': _firstNameController.text,
              'lastName': _lastNameController.text,
              'address': _addressController.text,
              'dateOfBirth': _dobController.text,
              'doctor': _doctorController.text,
              'email': _emailController.text,
              'gender': _selectedGender.toString().split('.').last, // Convert enum to string
              'contactNumber': _phoneController.text,
            }),
          );
          // Handle the redirected response
          print('Redirected response status code: ${redirectedResponse.statusCode}');
          print('Redirected response body: ${redirectedResponse.body}');
          // Show success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient Updated successfully'),
            ),
          );
          Navigator.pop(context); // Close the current screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PatientDetailsScreen(patientId: _patient.id)),
          );
        }
  } catch (error) {
    print('Error: $error');
  }
}
  }
