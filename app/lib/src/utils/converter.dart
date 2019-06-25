class Converter{
  ///String to int
  ///return 0 if input value is null or empty
  static int toInt(String value) => value == null || value == "" ? 0 : int.parse(value);

  ///2
  ///2.3
  ///0.4
  ///0
  ///0.0
  ///0.000001
  ///20000.3
  ///300000
  ///1.2
  ///1.
  ///0.
  ///.3
  static double toDouble(String value) => value == null || value == "" ? 0 : double.parse(value);

  ///String to DateTime
  ///return null if input value is null or empty
  static DateTime toDate(String date) => date == null || date == "" ? null : DateTime.parse(date);
}