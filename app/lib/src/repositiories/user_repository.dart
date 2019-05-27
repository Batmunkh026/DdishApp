import 'package:ddish/src/api/user_api_provider.dart';
import 'package:meta/meta.dart';

class UserRepository{
  final userApiProvider = UserApiProvider();

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    //TODO энд authenticate хийгээд token ийг нь persist хийх
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
    /// TODO token шалгах
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}