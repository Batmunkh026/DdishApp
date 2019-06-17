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

      
      if(_packReponse["isSuccess"])
        return List<Pack>.from(_packReponse["productList"].map((pack) => Pack.fromJson(pack)));

      //TODO success биш бол?
      return [];
    } on http.ClientException catch (e) {
      // TODO catch SocketException
      throw (e);
    }
  }

  ///Нэмэлт сувгуудын мэдээлэл авах
  Future<List<Channel>> fetchChannels(String productId) async{
    try {
      final _response = await client.read('${globals.serverEndpoint}/productList?productId=$productId');
      var _productList = json.decode(_response) as Map;


      if(_productList["isSuccess"])
        return List.from(_productList["additionalProducts"].map((channel) => Channel.fromJson(channel)));

      //TODO success биш бол?
      return [];
    } on http.ClientException catch (e) {
      // TODO catch SocketException
      throw (e);
    }
  }
}
