import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final bool rememberUsername;
  final bool useFingerprint;

  LoginButtonPressed({
    @required this.username,
    @required this.password,
    @required this.rememberUsername,
    @required this.useFingerprint,
  }) : super([username, password]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password, rememberUsername: $rememberUsername, useFingerprint: $useFingerprint }';
}
class ForgotPass extends LoginEvent{
  @override
  String toString() => 'Нууц үг мартсан ...';
}