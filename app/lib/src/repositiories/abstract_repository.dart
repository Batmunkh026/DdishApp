import 'dart:convert';

import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:oauth2/oauth2.dart';

abstract class AbstractRepository<B extends AbstractBloc> {
  final Logger log = new Logger('AbstractRepository');

  B bloc;

  @mustCallSuper
  AbstractRepository(this.bloc);

  final serverEndPoint = globals.serverEndpoint;

  ///get request
  ///
  /// param: [String] url param
  ///
  /// hasDecoded д false утга дамжуулвал jsonDecode хийхгүй response.body буцаана
  ///
  ///returns decoded json
  Future<dynamic> getResponse(String param, {hasDecoded = true}) async {
    var client = globals.client;
    log.info("http request param : $param");
    if (client.credentials.isExpired)
      bloc.connectionExpired(
          "session expired on credential.isExpired: ${bloc}");

    Response _response;
    try {
      _response = await client.get('$serverEndPoint/$param');
    } on Exception catch (e) {
      if (e is ExpirationException)
        bloc.connectionExpired(
            "session expired on abstract repo GET req: ${bloc}");
      log.warning("credential.isExpired: FALSE , but : session expired!");
//      throw (e);
    }

    if (_response == null || _response.statusCode == 404) return Map<dynamic, dynamic>.from({});

    if (!hasDecoded) return _response.body;

    var _decoded = json.decode(_response.body);

    log.info(_decoded.toString());

    if (_decoded['isSuccess'] == false &&
        _decoded['resultCode'] == 'Unauthorized') {
      bloc.connectionExpired(
          "session expired on : caused by server response > ${_decoded}");
      throw ExpirationException(globals.client.credentials);
    }
    return _decoded;
  }
}
