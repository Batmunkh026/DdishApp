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
          authorizationEndpoint, username, password,
          identifier: globals.identifier, secret: globals.secret);
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

  /// Хэрэглэгчийн мэдээллүүдийг авах
  Future<User> getUserInformation() async {
    var decoded = await getResponse('getUserInfo');
    User userInformation = User.fromJson(decoded);
    return userInformation;
  }

  /// Тоолуурын мэдээллийг авах
  Future<Counter> getMainCounter() async {
    var decoded = await getResponse('getUserInfo/main');
    Counter counter = Counter.fromJson(decoded['mainCounter']);
    return counter;
  }

  /// хадгалсан өгөгдлөөс хэрэглэгчийн нэрийг авах
  Future<String> getUsername() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
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

  /// хэрэглэгчийн мэдээллийг санах эсэх төлвийг авах
  Future<bool> isUsernameRemember()async {
    var prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('isUsernameRemember'))
      prefs.setBool('isUsernameRemember', false);
    return prefs.getBool('isUsernameRemember');
  }

  /// хэрэглэгчийн нэрийг санах эсэх төлвийг хадгалах
  Future<bool> rememberUsername(isRemember)async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setBool('isUsernameRemember', isRemember);
  }

  Future<bool> useFingerprint() async {
    var prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('useFingerprint'))
      prefs.setBool('useFingerprint', false);

    return prefs.getBool('useFingerprint');
  }

  Future<bool> rememberFingerprint(bool isRemember)async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setBool('useFingerprint', isRemember);
  }
}
