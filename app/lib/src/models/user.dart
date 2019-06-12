import 'package:ddish/src/models/counter_list.dart';
import 'package:ddish/src/models/product_list.dart';
import 'dart:convert';
import 'counter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: true, )
class User {
  final bool isSuccess;
  final String resultCode;
  final String resultMessage;
  final String cardNo;
  final String userFirstName;
  final String userLastName;
  final String userRegNo;
  final String adminNumber;
  final ProductList activeProducts;
  final CounterList activeCounters;

  User({this.isSuccess, this.resultCode, this.resultMessage, this.cardNo, this.userFirstName, this.userLastName, this.userRegNo, this.adminNumber, this.activeProducts, this.activeCounters});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
