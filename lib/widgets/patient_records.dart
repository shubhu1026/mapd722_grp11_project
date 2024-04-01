import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/record_card.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import '../constants/constants.dart';

class RecordsTab extends StatefulWidget {
  final String? patientID;

  const RecordsTab({Key? key, required this.patientID}) : super(key: key);

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
    final response = await http.get(Uri.parse('https://medicare-rest-api.onrender.com/patients/${widget.patientID}/medicalTests'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Record> records = data.map((json) => Record.fromJson(json)).toList();
      return records;
    } else {
      throw Exception('Failed to load records');
    }
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
