class VodChannel {
  final int productId;
  final String productName;
  final int channelNo;
  final String channelLogo;

  VodChannel.fromJson(Map<String, dynamic> json)
      : productId = int.parse(json['productId']),
        productName = json['productName'],
        channelLogo = json['channelLogo'],
        channelNo = int.parse(json['channelNo']);
}
