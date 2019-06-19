import 'package:ddish/src/models/counter_list.dart';
import 'package:ddish/src/models/product.dart';
import 'package:ddish/src/models/product_list.dart';
import 'package:ddish/src/models/result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(
  nullable: true,
)
class User {
  final Result result;
  final String cardNo;
  final String userFirstName;
  final String userLastName;
  final String userRegNo;
  final String adminNumber;
  final List<Product> activeProducts;
  final CounterList activeCounters;
  final List<Product> additionalProducts;

  User(
      {this.result,
      this.cardNo,
      this.userFirstName,
      this.userLastName,
      this.userRegNo,
      this.adminNumber,
      this.activeProducts,
      this.activeCounters,
      this.additionalProducts});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
