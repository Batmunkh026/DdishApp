import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/models/vod_channel.dart';

class VodChannelResponse {
  final Result result;
  final VodChannelList vodChannels;

  VodChannelResponse.fromJson(Map<String, dynamic> json)
      : result = Result.fromJson(json),
        vodChannels = VodChannelList.fromJson(json['vodChannels']);
}
