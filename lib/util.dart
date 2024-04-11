import 'package:intl/intl.dart';

class Util {
  static String? getFormattedDate(DateTime? dateTime, DateFormat formatter) {
    if (dateTime == null) return "";

    String? formatted;
    try {
      formatted = formatter.format(dateTime);
    } catch (e) {
      print(e);
    }
    return formatted;
  }

  static String? getFormattedTime(DateTime? dateTime, DateFormat formatter) {
    if (dateTime == null) return "";

    String? formattedTime;
    try {
      formattedTime = formatter.format(dateTime);
    } catch (e) {
      print(e);
    }
    return formattedTime;
  }
}