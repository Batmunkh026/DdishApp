///Багц
class Pack {
  Pack.fromJson(Map<String, dynamic> packMap):
    productId = packMap['productId'],
    name = packMap['productName'],
    image = packMap['productImg'],
    smsCode = packMap['smsCode'],
    price = double.parse(packMap['price']);


  String name;
  String productId;
  String image;
  String smsCode;
  DateTime expireDate;
  double price=0;
}

