import 'package:flutter/material.dart';

///Багц
class Pack {
  Pack(@required this.name, @required this.expireTime, @required this.image,
      @required this.packsForMonth)
      : assert(name != null),
        assert(expireTime != null),
        assert(image != null),
        assert(packsForMonth != null);

  String name;
  String image;
  DateTime
      expireTime;

//  сарын багцууд
  List<MonthAndPriceToExtend> packsForMonth;
}

class MonthAndPriceToExtend {
  int monthToExtend;//Сунгах сар
  int price; //<long> On the Dart VM an int is arbitrary precision and has no limit.

  MonthAndPriceToExtend(@required this.monthToExtend, @required this.price)
      : assert(monthToExtend != null);
}
