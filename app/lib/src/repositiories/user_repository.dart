import 'package:ddish/src/api/user_api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ddish/src/models/user.dart';
import 'package:ddish/src/models/counter.dart';
import 'package:ddish/src/models/pack.dart';

class UserRepository {
  final userApiProvider = UserApiProvider();
  final authorizationEndpoint = Uri.parse(globals.serverEndpoint + "/login");
  oauth2.Client client;

  Future<String> authenticate({
    @required String username,
    @required String password,
    @required bool rememberUsername,
    @required bool useFingerprint,
    @required bool fingerPrintLogin,
  }) async {
    var client;

    // TODO fingerPrintLogin
    try {
      client = await oauth2.resourceOwnerPasswordGrant(
          authorizationEndpoint, username, password);
    } on Exception catch (e) {
      throw e;
    }

    globals.client = client;
    var sharedPref = await SharedPreferences.getInstance();
    if (rememberUsername)
      sharedPref.setString('username', username);
    else if (sharedPref.getString('username') != null)
      sharedPref.remove('username');

    sharedPref.setBool('useFingerprint', useFingerprint);

    return client.credentials.accessToken;
  }

  Future<User> getUserInformation() async {
    Response response;
    try {
      response =
          await globals.client.get(globals.serverEndpoint + '/getUserInfo');
    } on Exception catch (e) {
      throw e;
    }

    debugPrint(response.body);
    var decoded = json.decode(response.body);
    User userInformation = User.fromJson(decoded);
    return userInformation;
  }

  Future<Counter> getMainCounter() async {
    var response;
    try {
      response = await globals.client
          .read(globals.serverEndpoint + '/getUserInfo?counter=main');
    } on Exception catch (e) {
      throw (e);
    }

    var decoded = json.decode(response);
    Counter counter = Counter.fromJson(decoded['mainCounter']);
    return counter;
  }

  Future<String> getUsername() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<bool> useFingerprint() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useFingerprint');
  }

  Future<void> deleteToken() async {
    //TODO token устгах
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// TODO token хадгалах
    /// https://pub.dev/packages/flutter_secure_storage ийг ашиглаж болох юм эсвэл shared_reference д ч юмуу
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    return false;
  }
}
