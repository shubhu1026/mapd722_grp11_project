// record.dart
class Record {
  String date;
  String diagnosis;
  String testType;
  String nurse;
  String testTime;
  String category;
  String readings;
  String condition;
  String id;

  Record({
    required this.date,
    required this.diagnosis,
    required this.testType,
    required this.nurse,
    required this.testTime,
    required this.category,
    required this.readings,
    required this.condition,
    required this.id,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      date: json['date'],
      diagnosis: json['diagnosis'],
      testType: json['testType'],
      nurse: json['nurse'],
      testTime: json['testTime'],
      category: json['category'],
      readings: json['readings'],
      condition: json['condition'],
      id: json['_id'],
    );
  }
}
