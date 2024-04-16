import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/providers/patient_details_provider.dart';
import 'package:mapd722_mobile_web_development/screens/patient_details_screen.dart';
import 'package:mapd722_mobile_web_development/screens/patients_screen.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/patients_provider.dart';
import '../util.dart';

class EditPatientDetailsScreen extends StatefulWidget {
  final Patient? patient;

  const EditPatientDetailsScreen({super.key, this.patient});

  @override
  _EditPatientDetailsScreenState createState() => _EditPatientDetailsScreenState();
}

enum Gender { Male, Female }

class _EditPatientDetailsScreenState extends State<EditPatientDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    _dobController.text = Util.getFormattedDate(
        DateTime.tryParse(patient.dateOfBirth ?? ''),
        DateFormat('yyyy-MM-dd')) ??
        '';

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
              const Text(
                'Patient Details',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: 'First Name',
                controller: _firstNameController,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: 'Last Name',
                controller: _lastNameController,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: 'Address',
                controller: _addressController,
                prefixIcon: Icons.home_work,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: 'Date of Birth',
                controller: _dobController,
                prefixIcon: Icons.calendar_month,
                onTap: () => _selectDate(context),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: 'Doctor\'s Name',
                controller: _doctorController,
                prefixIcon: Icons.medical_information,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: 'Email',
                controller: _emailController,
                prefixIcon: Icons.email,
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
                        value: Gender.Male,
                        groupValue: _selectedGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        activeColor: Constants.primaryColor,
                      ),
                      const Text('Male'),
                      Radio(
                        value: Gender.Female,
                        groupValue: _selectedGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _selectedGender = value;
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
                controller: _phoneController,
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.number,
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
                    'Save Changes'.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select gender'),
          ),
        );
        return;
      }

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
        Provider.of<PatientDetailsProvider>(context, listen: false).setPatientDetails(widget.patient!);
        Provider.of<PatientsProvider>(context, listen: false).updatePatientLists();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient details updated successfully'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PatientDetailsScreen(patientId: widget.patient!.id)),
        );
      }
      else if(response.statusCode == 307){
        final newUrl = response.headers['location'];

        // Make another POST request to the new URL
        final redirectedResponse = await http.put(
          Uri.parse(newUrl!),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(widget.patient!.toJson()),
        );
        if (redirectedResponse.statusCode == 200) {
          Provider.of<PatientDetailsProvider>(context, listen: false).setPatientDetails(widget.patient!);
          Provider.of<PatientsProvider>(context, listen: false).updatePatientLists();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Patient details updated successfully'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PatientDetailsScreen(patientId: widget.patient!.id)),
          );
        }
      }
      else {
        throw Exception('Failed to update patient details');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
