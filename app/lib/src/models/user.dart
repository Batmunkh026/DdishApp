import 'package:ddish/src/models/pack.dart';

import 'counter.dart';

class User {
  final String cartNo;
  final String userFirstName;
  final String userLastName;
  final int adminNumber;
  final List<Counter> activeCounters;
//  final List<Pack> activeProducts;

  User.fromJson(Map<String, dynamic> json)
      : cartNo = json['cartNo'],
        userFirstName = json['userFirstName'],
        userLastName = json['userLastName'],
        adminNumber = json['adminNumber'],
//        activeProducts = json['activeProducts'],
        activeCounters = json['activeCounters'];
}