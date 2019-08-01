import 'package:ddish/src/abstract/abstract.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'abstract_repository.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ddish/src/models/user.dart';
import 'package:ddish/src/models/counter.dart';

class UserRepository extends AbstractRepository {
  final authorizationEndpoint = Uri.parse(globals.serverEndpoint + "/login");

  UserRepository(AbstractBloc bloc) : super(bloc);

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
    super.client = client;

    var sharedPref = await SharedPreferences.getInstance();
    if (rememberUsername)
      sharedPref.setString('username', username);
    else if (sharedPref.getString('username') != null)
      sharedPref.remove('username');

    sharedPref.setBool('useFingerprint', useFingerprint);

    return client.credentials.accessToken;
  }

  Future<User> getUserInformation() async {
    var decoded = await getResponse('getUserInfo');
    User userInformation = User.fromJson(decoded);
    return userInformation;
  }

  Future<Counter> getMainCounter() async {
    var decoded = await getResponse('getUserInfo/main');
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
