import 'package:ddish/src/utils/converter.dart';
import 'package:equatable/equatable.dart';

///Багц
class Product extends Equatable {
  Product(this.id, this.name, this.image, this.smsCode, this.price,
      this.expireDate, this.isMain)
      : super([id, name, image, smsCode, price, expireDate, isMain]);

  Product.fromJson(Map<String, dynamic> map)
      : this(
            map['productId'],
            map['productName'],
            map['productImg'] == null ? "" : map['productImg'],
            map['smsCode'],
            Converter.toInt(map['price']),
            Converter.toDate(map['endDate']),
            map['isMain'] != null && map['isMain']);

  String name;
  String id;
  String image;
  String smsCode;
  DateTime expireDate;
  int price = 0;
  bool isMain = false;
}

class UpProduct extends Product {
  //сунгах хоног
  int convertDay;

  UpProduct(map) : super.fromJson(map) {
    this.convertDay = Converter.toInt(map["convertDay"]);
    super.price = Converter.toInt(map["amount"]);
  }

  UpProduct.fromJson(Map<String, dynamic> map) : this(map);
}

class Price {
  String productId;
  int month;
  int price;
  DateTime end;

  Price(this.productId, this.month, this.price, this.end);

  Price.fromJson(Map<String, dynamic> map)
      : this(
          map['productId'],
          Converter.toInt(map['month']),
          Converter.toInt(map['price']),
          Converter.toDate(map['endDate']),
        );
}
