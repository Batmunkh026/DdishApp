import 'package:intl/intl.dart';

class DateUtil {
  static var formatter = new DateFormat("yyyy-MM-dd");
  static var timeFormatter = new DateFormat('HH:mm');
  static var parameterFormatter = new DateFormat("yyyyMMdd");
  static var theatreDateFormatter = new DateFormat("yyyy|MM|dd");

  static DateTime toDateTime(String dateTime) {
    return DateTime.parse(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return formatter.format(dateTime);
  }

  static String formatParamDate(DateTime dateTime) {
    return parameterFormatter.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return timeFormatter.format(dateTime);
  }

  static String formatStringTime(String dateTime) {
    return formatTime(toDateTime(dateTime));
  }

  static String formatTheatreDate(DateTime dateTime) {
    return theatreDateFormatter.format(dateTime);
  }
}