import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'month_price.dart';

///Суваг
class Channel {
  Channel(@required this.name, @required this.expireTime, @required this.image,
      @required this.packsForMonth)
      : assert(name != null),
        assert(expireTime != null),
        assert(image != null),
        assert(packsForMonth != null);

  Channel.fromJson(Map<String, dynamic> channelMap)
      : name = channelMap['name'],
        expireTime = channelMap['expireTime'],
        image = channelMap['image'],
        packsForMonth = (json.decode(channelMap["packs"]) as List).map((v)=>MonthAndPriceToExtend.fromJson(v)).toList();

  String name;
  String image;
  DateTime expireTime;

  List<MonthAndPriceToExtend> packsForMonth;
}
