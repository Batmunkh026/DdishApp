import 'package:ddish/src/api/user_api_provider.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'globals.dart' as globals;

class UserRepository{
  final userApiProvider = UserApiProvider();
  final authorizationEndpoint = Uri.parse(globals.serverEndpoint + "/oauth/token");
  oauth2.Client client;

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    final clientId = "ddish-oauth2-client";
    final clientSecret = "ddish-oauth2-secret-password1234";

    var client;
    try {
      client = await oauth2.resourceOwnerPasswordGrant(
          authorizationEndpoint, username, password,
          identifier: clientId, secret: clientSecret);
    } on oauth2.AuthorizationException catch(e){
      throw e;
    }

    globals.client = client;
    return client.credentials.accessToken;
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