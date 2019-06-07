import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BaseApiProvider{
  final BASE_URL = "";

  bool responseReady(String url, http.Response response) {
    if (response.statusCode != 200) {
      debugPrint("$url  =>> Хариу байхгүй!");
      return false;
    }
    return true;
  }
}