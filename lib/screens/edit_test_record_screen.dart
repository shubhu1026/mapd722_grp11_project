import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:mapd722_mobile_web_development/providers/patient_records_provider.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/patients_provider.dart';
import '../util.dart';

class EditPatientRecordScreen extends StatefulWidget {
  final Record record;
  final String? patientId;

  const EditPatientRecordScreen({
    super.key,
    required this.record,
    required this.patientId,
  });

  @override
  _EditPatientRecordScreenState createState() => _EditPatientRecordScreenState();
}

class _EditPatientRecordScreenState extends State<EditPatientRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late Record _updatedRecord;

  final TextEditingController _testTypeController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _nurseController = TextEditingController();
  final TextEditingController _testDateController = TextEditingController();
  final TextEditingController _testTimeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _readingsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing record data
    _testTypeController.text = widget.record.testType;
    _diagnosisController.text = widget.record.diagnosis;
    _nurseController.text = widget.record.nurse;

    DateTime? parsedDate = DateTime.tryParse(widget.record.date ?? '');
    String formattedDate = Util.getFormattedDate(parsedDate, DateFormat('yyyy-MM-dd')) ?? '';
    _testDateController.text = formattedDate;


    DateTime parsedTime = DateTime.parse(widget.record.testTime);
    String formattedTime = DateFormat('HH:mm').format(parsedTime);
    _testTimeController.text = formattedTime;
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Test Details',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                  readOnly: true,
                  onTap: () {
                    _selectTime(context);
                  },
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 10,),
                CustomTextField(
                  labelText: 'Condition',
                  prefixIcon: Icons.medical_services,
                  controller: _conditionController,
                  readOnly: true,
                  onChanged: (value) {
                    setState(() {
                      _updatedRecord.condition = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constants.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Save Test'.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Get the current date
      final currentDate = DateTime.now();
      final date = DateFormat('yyyy-MM-dd').parse(_testDateController.text);

      // Create a new DateTime object using the selected time and the current date
      final selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Format the selected time
      final formattedTime = DateFormat('HH:mm').format(selectedDateTime);
      final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);

      setState(() {
        _testTimeController.text = formattedTime;
        _updatedRecord.testTime = formattedDateTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _updatedRecord.date) {
      // Format the picked date
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(pickedDate);

      // Update the text controller with formatted date
      _testDateController.text = formattedDate;

      // Update the record's date with formatted date string
      _updatedRecord.date = formattedDateTime;
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
      final date = DateTime.parse(_updatedRecord.date);
      final time = DateTime.parse(_updatedRecord.testTime);

      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      print(DateFormat('yyyy-MM-dd HH:mm').format(dateTime));

      _updatedRecord.date = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
      _updatedRecord.testTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

      final response = await http.put(
        Uri.parse('https://medicare-rest-api.onrender.com/patients/${widget.patientId}/medicalTests/${widget.record.id}'), // Replace with your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(_updatedRecord.toJson()),
      );

      if (response.statusCode == 200) {
        // Record updated successfully
        Provider.of<PatientRecordsProvider>(context, listen: false).updatePatientRecords(widget.patientId!);
        Provider.of<PatientsProvider>(context, listen: false).updatePatientLists();
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
