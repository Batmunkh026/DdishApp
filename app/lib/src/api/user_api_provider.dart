import 'dart:convert';

import 'package:ddish/src/models/pack.dart';
import 'package:http/http.dart' as http;
import 'base_api_provider.dart';

class UserApiProvider extends BaseApiProvider{

  ///Хэрэглэгчийн идэвхитэй багцыг авах
  Future<List<Pack>> fetchActivePacks()async{
    var loggedUserID="test";
    ///Нэмэлт сувгуудын мэдээлэл авах
      var userApiUrl = super.BASE_URL + '/user/active_pack';
      final response = await http.get(userApiUrl);

      if (responseReady(userApiUrl, response)) {
        var userJsons = json.decode(response.body) as List;

        List<Pack> userPacks =
        userJsons.map((channelJson) => Pack.fromJson(channelJson)).toList();

        return userPacks;
      }else
        return Future.value(List.of([]));
    }


}