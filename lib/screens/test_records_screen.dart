import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_mobile_web_development/providers/patient_details_provider.dart';
import 'package:mapd722_mobile_web_development/screens/add_test_record.dart';
import 'package:mapd722_mobile_web_development/widgets/patient_records.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/patient_records_provider.dart';
import '../providers/patients_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class TestRecordsScreen extends StatefulWidget {
  final String? patientID;

  const TestRecordsScreen({Key? key, required this.patientID})
      : super(key: key);

  @override
  _TestRecordsScreenState createState() => _TestRecordsScreenState();
}

class _TestRecordsScreenState extends State<TestRecordsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _showDeleteAllDialogBox(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete all records?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteAllRecords();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllRecords() async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://medicare-rest-api.onrender.com/patients/${widget.patientID}/medicalTests'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test record deleted successfully'),
          ),
        );

        Provider.of<PatientRecordsProvider>(context, listen: false)
            .updatePatientRecords(widget.patientID!);
        Provider.of<PatientsProvider>(context, listen: false)
            .updatePatientLists();
      } else {
        // Handle error
        throw Exception('Failed to delete test record');
      }
    } catch (error) {
      print('Error deleting test record: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete test record'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Test Records',
        onBack: () {
          Navigator.pop(context);
        },
        onMenu: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${Provider.of<PatientDetailsProvider>(context, listen: false)
                          .patient
                          .firstName}'s Test Records",
                  style: const TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                CircleAvatar(
                  radius: 30.0,
                  child: Image.asset('assets/images/patient_icon.png'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constants.primaryColor),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    const Text(
                      "Normal",
                      style: TextStyle(
                          color: Constants.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    const Text(
                      "Critical",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _showDeleteAllDialogBox(context);
                  },
                  child: Container(
                    child: const Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Constants.primaryColor,
                        ),
                        Text(
                          "Delete All Tests",
                          style: TextStyle(
                              color: Constants.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: RecordsTab(patientID: widget.patientID),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // Shadow color
                  spreadRadius: 5, // Spread radius
                  blurRadius: 7, // Blur radius
                  offset: Offset(0, 2), // Offset
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPatientRecordScreen(
                                  patientID: widget.patientID)),
                        );
                      },
                      tooltip: 'Add Test Record',
                      splashRadius: 24,
                      padding: const EdgeInsets.all(8),
                      icon: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Add Test Record',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
