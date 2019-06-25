class PriceFormatter {
  ///String эсвэл double байж болно
  static String productPriceFormat(dynamic price) {
    if (price == null || (price is String && price.isEmpty)) return "0";

    var values = price.toString().split(".");
    if (values.isEmpty) return price;

    return "${insertPrecisionChar(values[0])}${values.length > 1 ? ".${values[1]}" : ""}";
  }

  static String insertPrecisionChar(String value) {
    if (value == null || value.isEmpty) return "";

    var newValue = value.replaceAllMapped(
        RegExp(r"^([\d]+)([\d]{3}'[\d]+|[\d]{3})$"),
        (match) => "${match.group(1)}'${match.group(2)}");

    if (!newValue.startsWith(RegExp(r"[\d]{4,}"))) return newValue;

    return insertPrecisionChar(newValue);
  }
}
