///Суваг
class Channel {
  Channel.fromJson(Map<String, dynamic> channelMap)
      : name = channelMap['productName'],
        image = channelMap['productImg'],
        productId = int.parse(channelMap['productId']),
        smsCode = channelMap['smsCode'],
        price = double.parse(channelMap['price']);

  int productId;
  String name;
  String image;
  double price;
  String smsCode;
}
