import 'package:ddish/src/api/user_api_provider.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository{
  final userApiProvider = UserApiProvider();
  final authorizationEndpoint = Uri.parse("http://192.168.0.102:8086/oauth/token");

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    final clientId = "ddish-oauth2-client";
    final clientSecret = "ddish-oauth2-secret-password1234";

    oauth2.Client client;
    try {
      client = await oauth2.resourceOwnerPasswordGrant(
          authorizationEndpoint, username, password,
          identifier: clientId, secret: clientSecret);
    } on oauth2.AuthorizationException catch(e){
      return null;
    }

    final sharedPrefs =await SharedPreferences.getInstance();
    sharedPrefs.setString("access_token", client.credentials.accessToken);
    sharedPrefs.setString("refresh_token", client.credentials.refreshToken);
    return 'token';
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
    final sharedPrefs =await SharedPreferences.getInstance();
    return sharedPrefs.get("access_token") != null;
  }
}