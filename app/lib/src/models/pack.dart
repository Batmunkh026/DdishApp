import 'dart:convert';

import 'package:flutter/material.dart';

import 'month_price.dart';

///Багц
class Pack {
  Pack(@required this.name, @required this.expireTime, @required this.image,
      @required this.packsForMonth)
      : assert(name != null),
        assert(expireTime != null),
        assert(image != null),
        assert(packsForMonth != null);

  Pack.fromJson(Map<String, dynamic> packMap)
      : name = packMap['name'],
        expireTime = packMap['expireTime'],
        image = packMap['image'],
        packsForMonth = (json.decode(packMap["packs"]) as List).map((v)=>MonthAndPriceToExtend.fromJson(v)).toList();

  String name;
  String image;
  DateTime
      expireTime;

//  сарын багцууд
  List<MonthAndPriceToExtend> packsForMonth;
}

