import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

///Суваг
class Channel {
  Channel(@required this.name, @required this.expireTime, @required this.image)
      : assert(name != null),
        assert(expireTime != null),
        assert(image != null);

  Channel.fromJson(Map<String, dynamic> channelMap)
      : name = channelMap['name'],
        expireTime = channelMap['expireTime'],
        image = channelMap['image'];

  String name;
  String image;
  DateTime expireTime;
}
