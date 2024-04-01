import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';
import '../constants/constants.dart';

class EditPatientRecordScreen extends StatefulWidget {
  final Record record;
  final String? patientId;

  const EditPatientRecordScreen({
    Key? key,
    required this.record,
    required this.patientId,
  }) : super(key: key);

  @override
  _EditPatientRecordScreenState createState() => _EditPatientRecordScreenState();
}

class _EditPatientRecordScreenState extends State<EditPatientRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late Record _updatedRecord;

  TextEditingController _testTypeController = TextEditingController();
  TextEditingController _diagnosisController = TextEditingController();
  TextEditingController _nurseController = TextEditingController();
  TextEditingController _testTimeController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _conditionController = TextEditingController();
  TextEditingController _readingsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing record data
    _testTypeController.text = widget.record.testType;
    _diagnosisController.text = widget.record.diagnosis;
    _nurseController.text = widget.record.nurse;
    _testTimeController.text = widget.record.testTime;
    _categoryController.text = widget.record.category;
    _conditionController.text = widget.record.condition;
    _readingsController.text = widget.record.readings;

    // Initialize updated record with existing record data
    _updatedRecord = widget.record;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Test Record',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Test Details',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: 'Test Type',
                prefixIcon: Icons.list,
                controller: _testTypeController,
                onChanged: (value) {
                  setState(() {
                    _updatedRecord.testType = value;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: 'Diagnosis',
                prefixIcon: Icons.health_and_safety,
                controller: _diagnosisController,
                onChanged: (value) {
                  setState(() {
                    _updatedRecord.diagnosis = value;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: 'Nurse',
                prefixIcon: Icons.woman_rounded,
                controller: _nurseController,
                onChanged: (value) {
                  setState(() {
                    _updatedRecord.nurse = value;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: 'Test Time',
                prefixIcon: Icons.access_time,
                controller: _testTimeController,
                readOnly: true,
                onTap: () {
                  _selectTime(context);
                },
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: 'Category',
                prefixIcon: Icons.medical_information,
                controller: _categoryController,
                onChanged: (value) {
                  setState(() {
                    _updatedRecord.category = value;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: 'Condition',
                prefixIcon: Icons.medical_services,
                controller: _conditionController,
                onChanged: (value) {
                  setState(() {
                    _updatedRecord.condition = value;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: 'Readings',
                prefixIcon: Icons.numbers,
                controller: _readingsController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _updatedRecord.readings = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Save Test'.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Constants.primaryColor),
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      setState(() {
        _testTimeController.text = formattedTime;
        _updatedRecord.testTime = formattedTime;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Call the function to update the record
      await _updateRecord();
      // Close the screen
      Navigator.pop(context);
    }
  }

  Future<void> _updateRecord() async {
    try {
      final response = await http.put(
        Uri.parse('https://medicare-rest-api.onrender.com/patients/${widget.patientId}/medicalTests/${widget.record.id}'), // Replace with your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(_updatedRecord.toJson()),
      );

      if (response.statusCode == 200) {
        // Record updated successfully
        print('Record updated successfully');
      } else {
        // Handle the error
        print('Failed to update record. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating record: $error');
    }
  }
}
