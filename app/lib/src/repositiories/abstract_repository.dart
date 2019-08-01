import 'dart:convert';

import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:oauth2/oauth2.dart';

abstract class AbstractRepository<B extends AbstractBloc>{

  B bloc;

  @mustCallSuper
  AbstractRepository(this.bloc);

  var client = globals.client;
  final serverEndPoint = globals.serverEndpoint;

  ///get request
  ///
  /// param: [String] url param
  ///
  /// hasDecoded д false утга дамжуулвал jsonDecode хийхгүй response.body буцаана
  ///
  ///returns decoded json
  Future<dynamic> getResponse(String param, {hasDecoded = true}) async{
    debugPrint("http request param : $param");

    if(client.credentials.isExpired)
      bloc.connectionExpired();
    Response _response;
    try {
      _response = await client.get('$serverEndPoint/$param');
    } on Exception catch (e) {
      throw (e);
    }

    debugPrint(_response.body);

    if(!hasDecoded)
      return _response.body;

    var _decoded = json.decode(_response.body);

    debugPrint(_decoded.toString());

    return _decoded;
  }
}