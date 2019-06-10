import 'dart:io';

import 'package:ddish/src/api/user_api_provider.dart';
import 'package:ddish/src/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepository {
  final userApiProvider = UserApiProvider();
  final authorizationEndpoint =
      Uri.parse(globals.serverEndpoint + "/oauth/token");
  oauth2.Client client;

  Future<String> authenticate({
    @required String username,
    @required String password,
    @required bool rememberUsername,
    @required bool useFingerprint,
  }) async {
    final clientId = "ddish-oauth2-client";
    final clientSecret = "ddish-oauth2-secret-password1234";

    var client;
    try {
      client = await oauth2.resourceOwnerPasswordGrant(
          authorizationEndpoint, username, password,
          identifier: clientId, secret: clientSecret);
    } on oauth2.AuthorizationException catch (e) {
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
    var response;
//    try {
//      response = await globals.client.get(globals.ddishEndpoint + '/getUserInfo');
//    } on oauth2.AuthorizationException catch(e){
//      throw e;
//    }
    try {
      response = await http.post(globals.ddishEndpoint + '/getUserInfo',
          body: {'cardNo': "8097603536532789"});
      json.decode(response);
    } on Exception catch (e) {
      throw e;
    }

    var decoded = json.decode(response);
    User userInformation = User.fromJson(decoded);
    return userInformation;
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
