import 'package:flutter/foundation.dart';
import 'package:mapd722_mobile_web_development/models/record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecordsProvider with ChangeNotifier {
  List<Record> _records = [];

  List<Record> get records => _records;

  Future<void> fetchRecords(String? patientId) async {
    try {
      final response = await http.get(
        Uri.parse('https://medicare-rest-api.onrender.com/patients/$patientId/medicalTests'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        _records = responseData.map((data) => Record.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch records');
      }
    } catch (error) {
      print('Error fetching records: $error');
      throw error;
    }
  }
}
