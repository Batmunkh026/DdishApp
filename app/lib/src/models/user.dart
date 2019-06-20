import 'package:ddish/src/models/product.dart';

import 'counter.dart';

class User {
  final int cardNo;
  final String userFirstName;
  final String userLastName;
  final String userRegNo;
  final int adminNumber;
  final List<Product> activeProducts;
  final List<Counter> activeCounters;
  final List<Product> additionalProducts;

  User.fromJson(Map<String, dynamic> json)
      : cardNo = int.parse(json['cardNo']),
        userFirstName = json['userFirstName'],
        userLastName = json['userLastName'],
        adminNumber = int.parse(json['adminNumber']),
        userRegNo = json['userRegNo'],
        activeProducts = List<Product>.from(
            json['activeProducts'].map((product) => Product.fromJson(product))),
        activeCounters = List<Counter>.from(json['activeCounters']
            .map((counter) => Counter.fromJson(counter))),
        additionalProducts = List<Product>.from(json['additionalProducts']
            .map((product) => Product.fromJson(product)));
}
