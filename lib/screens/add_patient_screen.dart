import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/screens/patients_screen.dart';
import 'package:mapd722_mobile_web_development/screens/test_records_screen.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_drawer.dart';
import '../constants/constants.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

enum Gender { male, female }

class _AddPatientScreenState extends State<AddPatientScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  late Patient _patient;

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
    _patient = Patient(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Add Patient',
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
                      onSaved: (value) => _patient.firstName = value!,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Last Name',
                      prefixIcon: Icons.person,
                      controller: _lastNameController,
                      onSaved: (value) => _patient.lastName = value!,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Address',
                      prefixIcon: Icons.pin_drop,
                      controller: _addressController,
                      onSaved: (value) => _patient.address = value!,
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
                      onSaved: (value) => _patient.dateOfBirth = value!,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Doctor\'s Name',
                      prefixIcon: Icons.medical_information,
                      controller: _doctorController,
                      onSaved: (value) => _patient.doctor = value!,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Email',
                      prefixIcon: Icons.email,
                      controller: _emailController,
                      onSaved: (value) => _patient.email = value!,
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
                              value: Gender.male,
                              groupValue: _selectedGender,
                              onChanged: (Gender? value) {
                                setState(() {
                                  _selectedGender = value;
                                  _patient.gender = 'Male'; // Update the gender property
                                });
                              },
                              activeColor: Constants.primaryColor,
                            ),
                            Text('Male'),
                            Radio(
                              value: Gender.female,
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
                      onSaved: (value) => _patient.contactNumber = value!,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Submit'.toUpperCase(),
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}patients'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'address': _addressController.text,
            'dateOfBirth': _dobController.text,
            'gender': 'Male', // Or 'Female', based on your logic
            'email': _emailController.text,
            'contactNumber': _phoneController.text,
            'doctor': _doctorController.text,
          }),
        );

        // Check for redirection status code
        if (response.statusCode == 307) {
          // Extract the new URL from the Location header
          final newUrl = response.headers['location'];

          // Make another POST request to the new URL
          final redirectedResponse = await http.post(
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
              'gender': 'Male', // Or 'Female', based on your logic
              'email': _emailController.text,
              'contactNumber': _phoneController.text,
              'doctor': _doctorController.text,
            }),
          );

          // Handle the redirected response
          print('Redirected response status code: ${redirectedResponse.statusCode}');
          print('Redirected response body: ${redirectedResponse.body}');
          // Show success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient added successfully'),
            ),
          );
          // Navigate to patients screen
          Navigator.pop(context); // Close the current screen
          Navigator.pushReplacementNamed(context, '/patients'); // Go to patients screen
        } else {
          // Handle the response as usual
          print('Response status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          // Show success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient added successfully'),
            ),
          );
          // Navigate to patients screen
          Navigator.pop(context); // Close the current screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PatientsScreen()),
          );// Go to patients screen
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while adding the patient: $e'),
          ),
        );
      }
    }
  }



}
