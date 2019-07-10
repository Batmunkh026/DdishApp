import 'package:ddish/src/blocs/mixin/bloc_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginButtonPressed extends LoginEvent with NetworkAccessRequired {
  final String username;
  final String password;
  final bool rememberUsername;
  final bool useFingerprint;
  final bool fingerPrintLogin;
  final BuildContext context;

  LoginButtonPressed({
    @required this.username,
    @required this.password,
    @required this.rememberUsername,
    @required this.useFingerprint,
    @required this.fingerPrintLogin,
    @required this.context,
  }) : super([username, password]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password, rememberUsername: $rememberUsername, useFingerprint: $useFingerprint , fingerPrintLogin: $fingerPrintLogin}';
}
class ForgotPass extends LoginEvent{
  @override
  String toString() => 'Нууц үг мартсан ...';
}