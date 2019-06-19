import 'package:flutter/cupertino.dart';
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

  static String formatDateTime(DateTime dateTime) {
    return formatter.format(dateTime);
  }

  static String formatParamDateString(String date) {
    debugPrint(formatParamDate(toDateTime(date)));
    return formatParamDate(toDateTime(date));
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

  static String formatProductDate(DateTime dateTime) {
    if(dateTime == null)
      return "_";
    return productDateFormatter.format(dateTime);
  }

  static bool today(DateTime time) {
    var now = DateTime.now();
    var d1 = DateTime.utc(now.year, now.month, now.day);
    var d2 = DateTime.utc(
        time.year, time.month, time.day); //you can add today's date here
    return d2.compareTo(d1) == 0;
  }
}
