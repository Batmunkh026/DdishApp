import 'package:equatable/equatable.dart';

///Багц
class Product extends Equatable {
  Product(this.id, this.name, this.image, this.smsCode, this.price,
      this.expireDate, this.isMain):super([id, name, image, smsCode, price, expireDate, isMain]);

  Product.fromJson(Map<String, dynamic> map)
      : this(
            map['productId'],
            map['productName'],
            map['productImg'] == null ? "" : map['productImg'],
            map['smsCode'],
            map['price'] == null ? 0 : double.parse(map['price']),
            map['endDate'] == null ? null : DateTime.parse(map['endDate']),
            map['isMain'] == null ? false : map['isMain']);

  String name;
  String id;
  String image;
  String smsCode;
  DateTime expireDate;
  double price = 0;
  bool isMain = false;
}
