import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_drawer.dart';
import '../constants/constants.dart';

class EditPatientDetailsScreen extends StatefulWidget {
  @override
  _EditPatientDetailsScreenState createState() => _EditPatientDetailsScreenState();
}

enum Gender { male, female, other }

class _EditPatientDetailsScreenState extends State<EditPatientDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patient = Patient(
    id: '',
    firstName: '',
    lastName: '',
    address: '',
    email: '',
    gender: '',
    // Update gender property
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
                              value: Gender.male,
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

      // TODO: Process the patient data, e.g., save to database or perform other actions
      // For now, print the patient details
      print('Patient Details:');
      print('First Name: ${_patient.firstName}');
      print('Last Name: ${_patient.lastName}');
      print('Address: ${_patient.address}');
      print('DOB: ${_patient.dateOfBirth}');
      print('Doctor Name: ${_patient.doctor}');
      // ... Other patient details

      // TODO: Add logic to save the patient to your data source
    }
  }
}
