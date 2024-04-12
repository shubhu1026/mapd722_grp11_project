import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:mapd722_mobile_web_development/providers/patient_records_provider.dart';
import 'package:mapd722_mobile_web_development/screens/edit_test_record_screen.dart';
import 'package:mapd722_mobile_web_development/screens/test_records_screen.dart';
import 'package:mapd722_mobile_web_development/constants/constants.dart';
import 'package:provider/provider.dart';

import '../providers/patients_provider.dart';
import '../util.dart';

class RecordCard extends StatefulWidget {
  final Record record;
  final String? patientId;

  const RecordCard({
    required this.record,
    required this.patientId,
  });

  @override
  _RecordCardState createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  bool _expanded = false;

  Future<void> _deleteRecord() async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://medicare-rest-api.onrender.com/patients/${widget.patientId}/medicalTests/${widget.record.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test record deleted successfully'),
          ),
        );

        Provider.of<PatientRecordsProvider>(context, listen: false)
            .updatePatientRecords(widget.patientId!);
        Provider.of<PatientsProvider>(context, listen: false)
            .updatePatientLists();
      } else {
        // Handle error
        throw Exception('Failed to delete test record');
      }
    } catch (error) {
      print('Error deleting test record: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete test record'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = Constants.primaryColor;

    if (widget.record.condition.toLowerCase() == "critical") {
      cardColor = Colors.red;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
                leading: Icon(
                  Icons.file_copy,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  '${widget.record.testType}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              subtitle: Row(
                children: [
                  Text(
                    'Date: ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    Util.getFormattedDate(DateTime.tryParse(widget.record.date ?? ''),
                        DateFormat('dd MMM, yyyy')) ??
                        '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
                trailing:
                    IconButton(
                      icon: Icon(
                          _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                    ),
            ),
            if(!_expanded) SizedBox(height: 10,),
            if (_expanded) ..._buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAdditionalInfo() {
    return [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Divider(
          height: 1, // Height of the divider
          thickness: 1, // Thickness of the divider
          color: Colors.white,// Right indent
        ),
      ),
      _buildInfoItem('Diagnosis:', widget.record.diagnosis),
      _buildInfoItem('Nurse:', widget.record.nurse),
      _buildInfoItem(
        'Date:',
        Util.getFormattedTime(DateTime.tryParse(widget.record.testTime ?? ''),
                DateFormat('hh:mm a')) ??
            '',
      ),
      _buildInfoItem('Category:', widget.record.category),
      _buildInfoItem('Readings:', widget.record.readings),
      _buildInfoItem('Condition:', widget.record.condition),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Divider(
          height: 1, // Height of the divider
          thickness: 1, // Thickness of the divider
          color: Colors.white,// Right indent
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm Deletion'),
                    content: Text(
                        'Are you sure you want to delete this test record?'),
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
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "Delete",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(Icons.delete, color: Colors.white,),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditPatientRecordScreen(
                          record: widget.record,
                          patientId: widget.patientId)),
                );
              },
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "Edit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(Icons.edit_note, color: Colors.white,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //         child: TextButton(
      //           onPressed: () {},
      //           style: ButtonStyle(
      //             backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      //             foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //               RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(8.0),
      //               ),
      //             ),
      //           ),
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: <Widget>[
      //               Icon(Icons.edit),
      //               SizedBox(width: 8),
      //               Text("Edit"),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //     SizedBox(width: 80,),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //         child: TextButton(
      //           onPressed: () {},
      //           style: ButtonStyle(
      //             backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      //             foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //               RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(8.0),
      //               ),
      //             ),
      //           ),
      //           child:
      //           Row(
      //             mainAxisSize: MainAxisSize.max,
      //             children: <Widget>[
      //               Icon(Icons.delete),
      //               SizedBox(width: 8),
      //               Text("Delete"),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      SizedBox(
        height: 10,
      ),
    ];
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 15,),
            ),
          ),
        ],
      ),
    );
  }
}
