import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/record_card.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import '../constants/constants.dart';

class RecordsTab extends StatefulWidget {
  @override
  _RecordsTabState createState() => _RecordsTabState();
}

class _RecordsTabState extends State<RecordsTab> {
  late Future<List<Record>> _record;

  @override
  void initState() {
    super.initState();
    _record = fetchRecords();
  }

  Future<List<Record>> fetchRecords() async {
    // Dummy data for testing
    List<Map<String, dynamic>> dummyData = [
      {
        "date": "2023-12-24T01:21:12.336Z",
        "diagnosis": "High",
        "testType": "Blood Sugar Test",
        "nurse": "Sahil",
        "testTime": "2023-12-15T23:30:17.756Z",
        "category": "Evening Checkup",
        "readings": "200",
        "condition": "Critical",
        "_id": "657cfba24669fbbe7fce9fe4"
      },
      // Add more dummy data as needed
    ];

    // Parsing dummy data into Record model
    List<Record> records = dummyData.map((json) => Record.fromJson(json)).toList();
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Record>>(
      future: _record,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Constants.primaryColor),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No records found.'),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return RecordCard(record: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}
