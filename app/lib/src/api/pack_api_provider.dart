import 'dart:convert';

import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'base_api_provider.dart';

class PackApiProvider extends BaseApiProvider {
  ///Багцын мэдээлэл авах
  Future<List<Pack>> fetchPacks() async {
    var packApiUrl = super.BASE_URL + '/packs';
    final response = await http.get(packApiUrl);

    if (responseReady(packApiUrl, response)) {
      var packsJsons = json.decode(response.body) as List;

      List<Pack> packs =
          packsJsons.map((packsJson) => Pack.fromJson(packsJson)).toList();

      return packs;
    }else
      return Future.value(List.of([]));
  }

  ///Нэмэлт сувгуудын мэдээлэл авах
  Future<List<Channel>> fetchChannels() async{
      var channelApiUrl = super.BASE_URL + '/channels';
      final response = await http.get(channelApiUrl);

      if (responseReady(channelApiUrl, response)) {
        var channelsJsons = json.decode(response.body) as List;

        List<Channel> channels =
        channelsJsons.map((channelJson) => Channel.fromJson(channelJson)).toList();

        return channels;
      }else
        return Future.value(List.of([]));
  }

  bool responseReady(String url, http.Response response) {
    if (response.statusCode != 200) {
      debugPrint("$url  =>> Хариу байхгүй!");
      return false;
    }
    return true;
  }
}
