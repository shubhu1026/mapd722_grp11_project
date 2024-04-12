import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/providers/patients_provider.dart';
import 'package:mapd722_mobile_web_development/screens/patients_screen.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../widgets/patients_tab.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

enum Gender { male, female }

class _AddPatientScreenState extends State<AddPatientScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  late Patient _patient;

  Gender? _selectedGender;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Patient Details',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      CustomTextField(
                        labelText: 'First Name',
                        prefixIcon: Icons.person,
                        controller: _firstNameController,
                        onSaved: (value) => _patient.firstName = value!,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        labelText: 'Last Name',
                        prefixIcon: Icons.person,
                        controller: _lastNameController,
                        onSaved: (value) => _patient.lastName = value!,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        labelText: 'Address',
                        prefixIcon: Icons.pin_drop,
                        controller: _addressController,
                        onSaved: (value) => _patient.address = value!,
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      CustomTextField(
                        labelText: 'Doctor\'s Name',
                        prefixIcon: Icons.medical_information,
                        controller: _doctorController,
                        onSaved: (value) => _patient.doctor = value!,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        labelText: 'Email',
                        prefixIcon: Icons.email,
                        controller: _emailController,
                        onSaved: (value) => _patient.email = value!,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(width: 0.6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
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
                                    _patient.gender = 'Male';
                                  });
                                },
                                activeColor: Constants.primaryColor,
                              ),
                              const Text('Male'),
                              Radio(
                                value: Gender.female,
                                groupValue: _selectedGender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    _selectedGender = value;
                                    _patient.gender =
                                    'Female';
                                  });
                                },
                                activeColor: Constants.primaryColor,
                              ),
                              const Text('Female'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        labelText: 'Phone No.',
                        prefixIcon: Icons.phone,
                        controller: _phoneController,
                        onSaved: (value) => _patient.contactNumber = value!,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Submit'.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
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
            'gender': _selectedGender == Gender.male ? 'Male' : 'Female',
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
              'gender': _selectedGender == Gender.male ? 'Male' : 'Female',
              'email': _emailController.text,
              'contactNumber': _phoneController.text,
              'doctor': _doctorController.text,
            }),
          );

          // Handle the redirected response
          print('Redirected response status code: ${redirectedResponse.statusCode}');
          print('Redirected response body: ${redirectedResponse.body}');

          Provider.of<PatientsProvider>(context, listen: false).updatePatientLists();

          // Show success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Patient added successfully'),
            ),
          );
          // Navigate to patients screen
          Navigator.pop(context); // Close the current screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PatientsScreen()),
          ); // Go to patients screen
        } else {
          // Handle the response as usual
          if (kDebugMode) {
            print('Response status code: ${response.statusCode}');
            print('Response body: ${response.body}');
          }
          // Show success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
        if (kDebugMode) {
          print('Error: $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while adding the patient: $e'),
          ),
        );
      }
    }
  }
}
