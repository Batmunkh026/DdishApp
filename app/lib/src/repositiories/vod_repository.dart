import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/models/vod_channel_response.dart';
import 'dart:convert';
import 'package:ddish/src/models/program_response.dart';

import 'globals.dart' as globals;

class VodRepository {

  final client = globals.client;
  
  Future<VodChannelList> fetchVodChannels() async {
    var response;
    try {
      response = client.get('${globals.serverEndpoint}/vodList');
    } on Exception catch (e) {

    }
    var decoded = json.decode(response);
    VodChannelResponse channelResponse = VodChannelResponse.fromJson(decoded);
    // TODO handle isSuccess = false
    return channelResponse.vodChannels;

  }

  Future<ProgramList> fetchProgramList(VodChannel channel) async {
    var response;
    try {
      response = client.get('${globals.serverEndpoint}/vodList?productId=${channel.productId}');
    } on Exception catch (e) {

    }
    var decoded = json.decode(response);
    ProgramResponse channelResponse = ProgramResponse.fromJson(decoded);
    // TODO handle isSuccess = false
    return channelResponse.programList;
  }
}