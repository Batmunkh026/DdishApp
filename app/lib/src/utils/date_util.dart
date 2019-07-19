import 'package:intl/intl.dart';

class DateUtil {
  static var formatter = new DateFormat("yyyy-MM-dd");
  static var timeFormatter = new DateFormat('HH:mm');
  static var parameterFormatter = new DateFormat("yyyyMMdd");
  static var theatreDateFormatter = new DateFormat("dd | MM | yyyy");
  static var productDateFormatter = new DateFormat("dd.MM.yyyy");

  static DateTime toDateTime(String dateTime) {
    return DateTime.parse(dateTime);
  }

  ///yyyy-MM-dd
  static String formatDateTime(DateTime dateTime) {
    return formatter.format(dateTime);
  }

  ///yyyyMMdd
  static String formatParamDate(DateTime dateTime) {
    return parameterFormatter.format(dateTime);
  }

  ///HH:mm
  static String formatTime(DateTime dateTime) {
    return timeFormatter.format(dateTime);
  }

  ///dd | MM | yyyy
  static String formatTheatreDate(DateTime dateTime) {
    return theatreDateFormatter.format(dateTime);
  }

  ///dd.MM.yyyy
  static String formatProductDate(DateTime dateTime) {
    if (dateTime == null) return "_";
    return productDateFormatter.format(dateTime);
  }

  ///7 хоног дотор бол OK
  ///
  ///date.difference(7)
  static bool isValidProgramDate(DateTime time) {
    return time.difference(DateTime.now().add(Duration(days: 7))).inDays != 0;
  }

  static bool today(DateTime time) {
    var now = DateTime.now();
    var d1 = DateTime.utc(now.year, now.month, now.day);
    var d2 = DateTime.utc(time.year, time.month, time.day);
    return d2.compareTo(d1) == 0;
  }
}
