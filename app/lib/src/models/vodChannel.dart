import 'package:ddish/src/models/result.dart';

class VodChannel {
  final Result result;
  final String productId;
  final String productName;
  final String channelNo;

  VodChannel.fromJson(Map<String, dynamic> json)
      : result = Result.fromJson(json),
        productId = json['productId'],
        productName = json['productName'],
        channelNo = json['channelNo'];
}
