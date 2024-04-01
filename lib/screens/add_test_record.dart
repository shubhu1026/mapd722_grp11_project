import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_mobile_web_development/constants/constants.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';

class AddPatientRecordScreen extends StatefulWidget {
  final String? patientID;
  final Function refreshCallback;

  const AddPatientRecordScreen({Key? key, required this.patientID, required this.refreshCallback}) : super(key: key);

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

  TextEditingController _diagnosisController = TextEditingController();
  TextEditingController _nurseController = TextEditingController();
  TextEditingController _testDateController = TextEditingController(); // Controller for test date
  TextEditingController _testTimeController = TextEditingController(); // Controller for test time
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _conditionController = TextEditingController();
  TextEditingController _readingsController = TextEditingController();

  List<String> _testTypes = [
    'Blood Pressure Test',
    'Blood Sugar Test',
    'Cholesterol Test',
    'Complete Blood Count (CBC)',
  ];

  String _selectedTestType = '';

  // Map to store test type and condition thresholds
  final Map<String, Map<String, double>> _conditionThresholds = {
    'Blood Pressure Test': {'low': 90, 'high': 140},
    'Blood Sugar Test': {'low': 80, 'high': 180},
    'Cholesterol Test': {'high': 240},
    'Complete Blood Count (CBC)': {'low': 4.5, 'high': 10}
  };

  @override
  void initState() {
    super.initState();
    _selectedTestType = _testTypes.isNotEmpty ? _testTypes[0] : '';
  }

  void _handleRecordChanges() {
    widget.refreshCallback();
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
                    SizedBox(height: 1,),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey),
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
                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Text(
                                    testType,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Test Type',
                              prefixIcon: Icon(Icons.list, color: Colors.grey),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Diagnosis',
                          prefixIcon: Icons.health_and_safety,
                          controller: _diagnosisController,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Nurse',
                          prefixIcon: Icons.woman_rounded,
                          controller: _nurseController,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Test Date',
                          prefixIcon: Icons.calendar_today,
                          controller: _testDateController,
                          onTap: () {
                            _selectDate(context);
                          },
                          readOnly: true,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Test Time',
                          prefixIcon: Icons.access_time,
                          controller: _testTimeController,
                          onTap: () {
                            _selectTime(context);
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
                          labelText: 'Readings',
                          prefixIcon: Icons.numbers,
                          controller: _readingsController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _updateCondition(value ?? '0');
                          }, // Add onChanged here
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Condition',
                          prefixIcon: Icons.medical_services,
                          controller: _conditionController,
                          readOnly: true,
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
          Uri.parse('https://medicare-rest-api.onrender.com/patients/${widget.patientID}/medicalTests'),
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

          _handleRecordChanges();
          // Close the screen or navigate back
          Navigator.pop(context);
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
