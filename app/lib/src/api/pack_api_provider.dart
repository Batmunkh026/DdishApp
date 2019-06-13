import 'dart:convert';

import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:http/http.dart' as http;

import 'base_api_provider.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;

class PackApiProvider extends BaseApiProvider {
  final client = globals.client;
  ///Багцын мэдээлэл авах
  Future<List<Pack>> fetchPacks() async {
    try {
      final _response = await client.read('${globals.serverEndpoint}/productList');
      var _packReponse = json.decode(_response) as Map;

      
      if(_packReponse["isSuccess"]){
        List<Pack> packs = _packReponse["productList"].map((pack) => Pack.fromJson(pack)).toList();
        return packs;
      }
      //TODO success биш бол?
      return [];
    } on http.ClientException catch (e) {
      // TODO catch SocketException
      throw (e);
    }
  }

  ///Нэмэлт сувгуудын мэдээлэл авах
  Future<List<Channel>> fetchChannels() async{
    try {
      final _response = await client.read('${globals.serverEndpoint}/channelList');
      var _packReponse = json.decode(_response) as Map;


      if(_packReponse["isSuccess"]){
        List<Channel> channels = _packReponse["channelList"].map((channel) => Channel.fromJson(channel)).toList();
        return channels;
      }
      //TODO success биш бол?
      return [];
    } on http.ClientException catch (e) {
      // TODO catch SocketException
      throw (e);
    }
  }
}
