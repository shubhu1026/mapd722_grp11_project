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
  final Patient? patient;

  const EditPatientDetailsScreen({Key? key, this.patient}) : super(key: key);

  @override
  _EditPatientDetailsScreenState createState() => _EditPatientDetailsScreenState();
}

enum Gender { Male, Female }

class _EditPatientDetailsScreenState extends State<EditPatientDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    if (widget.patient != null) {
      _populateControllers();
      _selectedGender = widget.patient!.gender == 'Male' ? Gender.Male : Gender.Female;
    }
  }

  void _populateControllers() {
    final patient = widget.patient!;
    _firstNameController.text = patient.firstName;
    _lastNameController.text = patient.lastName;
    _addressController.text = patient.address;
    _dobController.text = patient.dateOfBirth;
    _doctorController.text = patient.doctor;
    _emailController.text = patient.email;
    _phoneController.text = patient.contactNumber;
  }

  @override
  Widget build(BuildContext context) {
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
          child: ListView(
            children: [
              Text(
                'Patient Details',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'First Name',
                controller: _firstNameController,
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Last Name',
                controller: _lastNameController,
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Address',
                controller: _addressController,
                prefixIcon: Icons.home_work,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Date of Birth',
                controller: _dobController,
                prefixIcon: Icons.calendar_month,
                onTap: () => _selectDate(context),
                readOnly: true,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Doctor\'s Name',
                controller: _doctorController,
                prefixIcon: Icons.medical_information,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Email',
                controller: _emailController,
                prefixIcon: Icons.email,
              ),
              SizedBox(height: 20),
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
                            _selectedGender = value as Gender?;
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
                            _selectedGender = value as Gender?;
                          });
                        },
                        activeColor: Constants.primaryColor,
                      ),
                      Text('Female'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Phone No.',
                controller: _phoneController,
                prefixIcon: Icons.phone,
              ),
              SizedBox(height: 20),
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Update patient object with new values
      widget.patient!.firstName = _firstNameController.text;
      widget.patient!.lastName = _lastNameController.text;
      widget.patient!.address = _addressController.text;
      widget.patient!.dateOfBirth = _dobController.text;
      widget.patient!.doctor = _doctorController.text;
      widget.patient!.email = _emailController.text;
      widget.patient!.gender = _selectedGender == Gender.Male ? 'Male' : 'Female';
      widget.patient!.contactNumber = _phoneController.text;

      // Call function to update patient details
      _updatePatientDetails();
    }
  }

  Future<void> _updatePatientDetails() async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}patients/${widget.patient!.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(widget.patient!.toJson()),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Patient details updated successfully'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PatientDetailsScreen(patientId: widget.patient!.id)),
        );
      } else {
        throw Exception('Failed to update patient details');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
