class VodChannel {
  final String productId;
  final String productName;
  final String channelNo;

  VodChannel.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        productName = json['productName'],
        channelNo = json['channelNo'];
}
