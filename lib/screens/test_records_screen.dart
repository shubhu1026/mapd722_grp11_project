import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/screens/add_test_record.dart';
import 'package:mapd722_mobile_web_development/widgets/patient_records.dart';
class TestRecordsScreen extends StatefulWidget {
  final String? patientID;

  const TestRecordsScreen({Key? key, required this.patientID}) : super(key: key);

  @override
  _TestRecordsScreenState createState() => _TestRecordsScreenState();
}

class _TestRecordsScreenState extends State<TestRecordsScreen> {
  void refreshRecords() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Records'),
        backgroundColor: Color(0xFF007CFF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Color(0xFF007CFF),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.red,
                        margin: EdgeInsets.only(right: 8),
                      ),
                      Text(
                        'Critical - Red',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.white,
                        margin: EdgeInsets.only(right: 8),
                      ),
                      Text(
                        'Normal - White',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 255, 255, 255),
              child: RecordsTab(patientID: widget.patientID, refreshCallback: refreshRecords,),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add test record screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPatientRecordScreen(patientID: widget.patientID, refreshCallback: refreshRecords,)),
          ).then((testRecord) {
            // After adding test record, update the list
            if (testRecord != null) {
              setState(() {
                // testRecords.add(testRecord);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
