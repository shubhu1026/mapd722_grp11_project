import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:mapd722_mobile_web_development/screens/edit_test_record_screen.dart';
import 'package:mapd722_mobile_web_development/screens/test_records_screen.dart';
import 'package:mapd722_mobile_web_development/constants/constants.dart';

class RecordCard extends StatefulWidget {
  final Record record;
  final String? patientId; // Patient ID

  const RecordCard({
    required this.record,
    required this.patientId, // Receive patient ID
  });

  @override
  _RecordCardState createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  bool _expanded = false;

  Future<void> _deleteRecord() async {
    try {
      final response = await http.delete(
        Uri.parse('https://medicare-rest-api.onrender.com/patients/${widget.patientId}/medicalTests/${widget.record.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        // Handle success
        // For example, show a SnackBar indicating successful deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test record deleted successfully'),
          ),
        );
        // Optionally, you can update the UI to reflect the deletion
        // For example, you may want to remove the record from the list
      } else {
        // Handle error
        throw Exception('Failed to delete test record');
      }
    } catch (error) {
      print('Error deleting test record: $error');
      // Handle error
      // For example, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete test record'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = Colors.white; // Default color is white

    // Check if the condition is critical, then change the cardColor to primary color
    if (widget.record.condition.toLowerCase() == "critical") {
      cardColor = Constants.primaryColor; // Use primary color from constants
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.record.testType}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>  EditPatientRecordScreen(record: widget.record, patientId: widget.patientId,)),);

                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text('Are you sure you want to delete this test record?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteRecord();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (_expanded) ..._buildAdditionalInfo(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAdditionalInfo() {
    return [
      _buildInfoItem('Date:', widget.record.date),
      _buildInfoItem('Diagnosis:', widget.record.diagnosis),
      _buildInfoItem('Nurse:', widget.record.nurse),
      _buildInfoItem('Test Time:', widget.record.testTime),
      _buildInfoItem('Category:', widget.record.category),
      _buildInfoItem('Readings:', widget.record.readings),
      _buildInfoItem('Condition:', widget.record.condition),
    ];
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
