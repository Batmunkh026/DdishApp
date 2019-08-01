import 'package:flutter/services.dart';

enum InputType { NumberInt, NumberDouble, Text, Email }

class InputValidations {
  static Map<InputType, WhitelistingTextInputFormatter> acceptedFormatters = {
    InputType.NumberInt: WhitelistingTextInputFormatter(RegExp(r'\d+')),

    //2
    //2.3
    //0.4
    //0
    //0.0
    //0.000001
    //20000.3
    //300000
    //1.2
    //1.
    //0.
    //.3
    InputType.NumberDouble: WhitelistingTextInputFormatter(
        RegExp(r'^(?:((\d+)|([\.]{1}\d+))+|\d+\.|\d+\.\d+)$')),
  };

  static String validateNumberValue(String value) {
    if (value.isEmpty) return 'Утга оруулна уу!';
    final RegExp usernameRegex = new RegExp(r'^\d+$');
    if (!usernameRegex.hasMatch(value)) return 'Тоон утга оруулна уу.';
    return null;
  }
  static String validatePhoneNumber(String value) {
    if (value.isEmpty) return 'Утга оруулна уу!';
    final RegExp usernameRegex = new RegExp(r'^[\d+]{8}$');
    if (!usernameRegex.hasMatch(value)) return 'Утасны дугаараа зөв оруулна уу.';
    return null;
  }

  static String validateNotNullValue(String value) {
    if (value.isEmpty) return 'Утга оруулна уу.';
    return null;
  }

  static String validateName(String value) {
    if (value.isEmpty) return 'Нэрээ оруулна уу!';
    final RegExp nameExp = new RegExp(r'^[А-ЯӨҮЁа-яөүёA-za-z \.-]+$');
    if (!nameExp.hasMatch(value))
      return 'Зөвхөн үсэг болон [. -]  тэмдэгтүүд оруулна уу.';
    return null;
  }
}
