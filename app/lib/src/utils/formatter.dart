import 'package:flutter/widgets.dart';

class PriceFormatter {
  ///String эсвэл double байж болно
  static String productPriceFormat(dynamic price) {
    if (price == null || (price is String && price.isEmpty)) return "0";

    var values = price.toString().split(".");
    if (values.isEmpty) return price;

    return "${_insertPrecisionChar(values[0])}${values.length > 1 ? ".${values[1]}" : ""}";
  }

  static String _insertPrecisionChar(String value) {
    if (value == null || value.isEmpty) return "";

    var newValue = value.replaceAllMapped(
        RegExp(r"^([\d]+)([\d]{3}'[\d]+|[\d]{3})$"),
        (match) => "${match.group(1)}'${match.group(2)}");

    if (!newValue.startsWith(RegExp(r"[\d]{4,}"))) return newValue;

    return _insertPrecisionChar(newValue);
  }
}

class StringFormatter {
  ///утасны дугаарыг 4 оронгоор зай авах
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber == null) return "";

    int lengthOfPart = 4;

    String result = "";

    try {
      for (int i = 0; i < phoneNumber.length; i = i + lengthOfPart)
        result += phoneNumber.substring(i, i + lengthOfPart) + " ";
    } catch (e) {
      debugPrint(e);
    }

    return result;
  }

  ///картын дугаарыг форматлах
  ///
  /// Хэрэв картын дугаар нь :
  ///
  ///   null бол хоосон string буцаана
  ///
  ///   хэрэв картын дугаар 16 оронтой бол [8 0976 02 99712063 9]
  ///
  ///   хэрэв картын дугаар 12 оронтой бол [21 3016 4151 58]
  ///
  ///   үгүй бол тухайн өгөгдсөн дугаарыг буцаана
  ///
  String formatCardNumber(String cardNumber) {
    if (cardNumber == null) return "";
    String result = cardNumber;

    try {
      if (result.length == 16)
        result =
            "${result.substring(0, 1)} ${result.substring(1, 5)} ${result.substring(5, 7)} ${result.substring(7, 15)} ${result.substring(15, 16)}";
      else if (result.length == 12)
        result =
            "${result.substring(0, 2)} ${result.substring(2, 6)} ${result.substring(6, 10)} ${result.substring(10, 12)}";
      else
        debugPrint("тохиромжгүй формат");
    } catch (e) {
      debugPrint(e);
    }

    return result;
  }

  ///тоон утга эсэх
  bool isNumeric(String value) =>
      value != null &&
      (num.tryParse(value) != null || double.tryParse(value) != null);
}
