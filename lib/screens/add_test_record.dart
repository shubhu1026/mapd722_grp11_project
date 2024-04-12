import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_mobile_web_development/constants/constants.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:mapd722_mobile_web_development/providers/patients_provider.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../providers/patient_records_provider.dart';

class AddPatientRecordScreen extends StatefulWidget {
  final String? patientID;

  const AddPatientRecordScreen({Key? key, required this.patientID})
      : super(key: key);

  @override
  _AddPatientRecordsScreenState createState() =>
      _AddPatientRecordsScreenState();
}

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

  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _nurseController = TextEditingController();
  final TextEditingController _testDateController = TextEditingController();
  final TextEditingController _testTimeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _readingsController = TextEditingController();

  final List<String> _testTypes = [
    'Blood Pressure Test',
    'Blood Sugar Test',
    'Cholesterol Test',
    'Complete Blood Count (CBC)',
  ];

  String _selectedTestType = '';

  final Map<String, Map<String, double>> _conditionThresholds = {
    'Blood Pressure Test': {'low': 90, 'high': 140},
    'Blood Sugar Test': {'low': 80, 'high': 180},
    'Cholesterol Test': {'low': 50, 'high': 180},
    'Complete Blood Count (CBC)': {'low': 4.5, 'high': 10}
  };

  final Map<String, Map<String, double>> _inputThresholds = {
    'Blood Pressure Test': {'min': 50, 'max': 220},
    'Blood Sugar Test': {'min': 30, 'max': 450},
    'Cholesterol Test': {'min': 40, 'max': 240},
    'Complete Blood Count (CBC)': {'min': 3.0, 'max': 14.2},
  };

  @override
  void initState() {
    super.initState();
    _selectedTestType = _testTypes.isNotEmpty ? _testTypes[0] : '';
  }

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
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 1,
                    ),
                    Column(
                      children: [
                        const Text(
                          'Test Details',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.black, width: 0.65),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedTestType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedTestType = newValue!;
                              });
                            },
                            items: _testTypes.map((String testType) {
                              return DropdownMenuItem<String>(
                                value: testType,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    testType,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Test Type',
                              prefixIcon: Icon(Icons.list, color: Constants.primaryColor),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Diagnosis',
                          prefixIcon: Icons.health_and_safety,
                          controller: _diagnosisController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Nurse',
                          prefixIcon: Icons.woman_rounded,
                          controller: _nurseController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Test Date',
                          prefixIcon: Icons.calendar_today,
                          controller: _testDateController,
                          onTap: () {
                            _selectDate(context);
                          },
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Test Time',
                          prefixIcon: Icons.access_time,
                          controller: _testTimeController,
                          onTap: () {
                            _selectTime(context);
                          },
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Category',
                          prefixIcon: Icons.medical_information,
                          controller: _categoryController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Readings',
                          prefixIcon: Icons.numbers,
                          controller: _readingsController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _updateCondition(value ?? '0');
                          },
                          onEditingComplete: () {
                            _limitValues(_readingsController.text ?? '0');
                          }, // Add onChanged here
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Condition',
                          prefixIcon: Icons.medical_services,
                          controller: _conditionController,
                          readOnly: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Constants.primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Add Test'.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
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

    if (pickedDate != null && pickedDate != _record.date) {
      _testDateController.text = pickedDate.toLocal().toString().split(' ')[0];
      _record.date = _testDateController.text;
    }
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
        _record.testTime = formattedTime;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final provider =
            Provider.of<PatientRecordsProvider>(context, listen: false);

        final newRecord = Record(
          testType: _selectedTestType,
          diagnosis: _diagnosisController.text,
          nurse: _nurseController.text,
          // Concatenate the date and time strings to form the complete datetime string
          testTime: '${_testDateController.text} ${_testTimeController.text}',
          category: _categoryController.text,
          date: _testDateController.text,
          condition: _conditionController.text,
          readings: _readingsController.text,
        );

        final response = await http.post(
          Uri.parse(
              'https://medicare-rest-api.onrender.com/patients/${widget.patientID}/medicalTests'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(newRecord.toJson()),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Test added successfully
          final jsonResponse = json.decode(response.body);
          final newRecordId = jsonResponse['id'] as String?;

          // Perform any necessary actions with the new record ID
          print('New record ID: $newRecordId');

          await provider.updatePatientRecords(widget.patientID!);
          Provider.of<PatientsProvider>(context, listen: false)
              .updatePatientLists();
          // Close the screen or navigate back
          Navigator.pop(context);
        } else if (response.statusCode == 307) {
          // Extract the new URL from the Location header
          final newUrl = response.headers['location'];

          // Make another POST request to the new URL
          final redirectedResponse = await http.post(
            Uri.parse(newUrl!),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(newRecord.toJson()),
          );

          if (redirectedResponse.statusCode == 200 ||
              redirectedResponse.statusCode == 201) {
            await provider.updatePatientRecords(widget.patientID!);
            Provider.of<PatientsProvider>(context, listen: false)
                .updatePatientLists();
          }
        } else {
          // Print error message only if there's an error response from the server
          print('Failed to add new test: ${response.statusCode}');
        }
      } catch (error) {
        // Print error message if an exception occurs
        print('Error adding new test: $error');
      }
    }
  }

  void _limitValues(String value) {
    if (value.isNotEmpty && _selectedTestType.isNotEmpty) {
      final thresholds = _inputThresholds[_selectedTestType];
      if (thresholds != null) {
        final double reading = double.tryParse(value) ?? 0.0;
        if (reading > thresholds['max']!) {
          setState(() {
            _readingsController.text = thresholds['max'].toString();
            _record.readings = _readingsController.text;
          });
        } else if (reading < thresholds['min']!) {
          setState(() {
            _readingsController.text = thresholds['min'].toString();
            _record.readings = _readingsController.text;
          });
        }
      }
    }
  }

  void _updateCondition(String value) {
    if (value.isNotEmpty && _selectedTestType.isNotEmpty) {
      final thresholds = _conditionThresholds[_selectedTestType];
      if (thresholds != null) {
        final double reading = double.tryParse(value) ?? 0.0;
        if (reading >= (thresholds['low'] ?? double.negativeInfinity) &&
            reading <= (thresholds['high'] ?? double.infinity)) {
          setState(() {
            _conditionController.text = 'Normal';
            _record.condition = 'Normal';
          });
        } else {
          setState(() {
            _conditionController.text = 'Critical';
            _record.condition = 'Critical';
          });
        }
      }
    }
  }
}
