class Converter{
  ///String to int
  ///return 0 if input value is null or empty
  static int toInt(String value) => value == null || value == "" ? 0 : int.parse(value);

  ///String to DateTime
  ///return null if input value is null or empty
  static DateTime toDate(String date) => date == null || date == "" ? null : DateTime.parse(date);
}