class PriceFormatter {
  static String productPriceFormat(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r"^([\d]+)([\d]{3}'[\d]+|[\d]{3})$"),
        (match) => "${match.group(1)}'${match.group(2)}");
  }
}
