import 'package:flutter/material.dart';

///Багц
///TODO Багцын үнийг сараар яаж тооцох?
class Collection {
  Collection(
      @required this.name,
      @required this.totalPrice,
      @required this.expireTime,
      @required this.image,
      @required this.monthToExtend)
      : assert(name != null),
        assert(totalPrice != null),
        assert(expireTime != null),
        assert(image != null),
        assert(monthToExtend != null);

  String name;
  NetworkImage image; //TODO өгөгдлийн төрлийг тодруулах
  DateTime
      expireTime; //TODO дуусах хугацааны өгөгдлийн төрлийг тодруулах. Date or DateTime

  //TODO үнийн дүн сунгах сар 2 тусдаа байх эсэхийг тодруулах
  int monthToExtend;
  int totalPrice; //TODO үнийн дүнгийн өгөглийн төрлийг тодруулах
}
