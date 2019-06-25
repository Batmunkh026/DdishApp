class PriceFormatter {
  ///String эсвэл double байж болно
  static String productPriceFormat(dynamic price) {
    if (price == null || (price is String && price.isEmpty)) return "0";

    var values = price.toString().split(".");

    return values[0].replaceAllMapped(RegExp(r"^([\d]+)([\d]{3}'[\d]+|[\d]{3})$"),
        (match) => "${match.group(1)}'${match.group(2)}")+"${values.length > 1 ? ".${values[1]}" : ""}";
  }
}
