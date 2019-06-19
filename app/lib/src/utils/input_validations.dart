class InputValidations {
  static String validateNumberValue(String value) {
    if (value.isEmpty) return 'Утга оруулна уу!';
    final RegExp usernameRegex = new RegExp(r'^\d+$');
    if (!usernameRegex.hasMatch(value)) return 'Тоон утга оруулна уу.';
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
