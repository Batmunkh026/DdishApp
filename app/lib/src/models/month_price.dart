import 'package:meta/meta.dart';

class MonthAndPriceToExtend {
  int monthToExtend;//Сунгах сар
  int price; //<long> On the Dart VM an int is arbitrary precision and has no limit.

  MonthAndPriceToExtend(@required this.monthToExtend, @required this.price)
      : assert(monthToExtend != null);

  MonthAndPriceToExtend.fromJson(Map<String, dynamic> json)
      : monthToExtend = json['month'],
        price = json['price'];
}
