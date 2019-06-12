import 'package:intl/intl.dart';

class DateUtil {
  static var formatter = new DateFormat("yyyy-MM-dd");

  static DateTime toDateTime(String dateTime) {
    return DateTime.parse(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return formatter.format(dateTime);
  }
}