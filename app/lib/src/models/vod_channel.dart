class VodChannel {
  final String productId;
  final String productName;
  final String channelNo;
  final String channelLogo;

  VodChannel.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        productName = json['productName'],
        channelLogo = json['channelLogo'],
        channelNo = json['channelNo'];
}

class VodChannelList {
  final List<VodChannel> vodChannels;

  VodChannelList({this.vodChannels});

  factory VodChannelList.fromJson(List<dynamic> parsedJson) {
    List<VodChannel> channels = parsedJson.map((i) => VodChannel.fromJson(i))
        .toList();
    return VodChannelList(
      vodChannels: channels,
    );
  }
}