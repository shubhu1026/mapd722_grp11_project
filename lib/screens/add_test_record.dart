import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';
import '../constants/constants.dart';

class AddPatientRecordScreen extends StatefulWidget {
  @override
  _AddPatientRecordsScreenState createState() => _AddPatientRecordsScreenState();
}

enum Gender { male, female, other }

class _AddPatientRecordsScreenState extends State<AddPatientRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _record = Record(
    id: '',
    testType: '',
    diagnosis: '',
    nurse: '',
    testTime: '',
    category: '',
    date: '',
    condition: '',
    readings: '',
  );

  TextEditingController _testTypeController = TextEditingController();
  TextEditingController _diagnosis = TextEditingController();
  TextEditingController _nurseController = TextEditingController();
  TextEditingController _testTimeController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _conditionController = TextEditingController();
  TextEditingController _ReadingsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Test Record',
        onBack: () {
          Navigator.pop(context);
        },
        onMenu: () {
          print('Custom menu button pressed!');
        },
      ),
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
                  'Test Details',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                Column(
                  children: [
                    CustomTextField(
                      labelText: 'Test Type',
                      prefixIcon: Icons.list,
                      controller: _testTypeController,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Diagnosis',
                      prefixIcon: Icons.health_and_safety,
                      controller: _diagnosis,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'nurse',
                      prefixIcon: Icons.woman_rounded,
                      controller: _nurseController,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Test Time',
                      prefixIcon: Icons.calendar_month,
                      controller: _testTimeController,
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Category',
                      prefixIcon: Icons.medical_information,
                      controller: _categoryController,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Condition',
                      prefixIcon: Icons.medical_services,
                      controller: _conditionController,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Readings',
                      prefixIcon: Icons.numbers,
                      controller: _ReadingsController,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Add Test'.toUpperCase(),
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

    if (pickedDate != null && pickedDate != _record.date) {
      _testTimeController.text = pickedDate.toLocal().toString().split(' ')[0];
      _record.date = _testTimeController.text;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // TODO: Process the patient data, e.g., save to database or perform other actions
      // For now, print the patient details
      print('Patient Details:');
      print('First Name: ${_record.testType}');
      print('Last Name: ${_record.diagnosis}');
      print('Address: ${_record.date}');
      print('DOB: ${_record.nurse}');
      print('Doctor Name: ${_record.condition}');
      // ... Other patient details

      // TODO: Add logic to save the patient to your data source
    }
  }
}
