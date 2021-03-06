import 'dart:io';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:flutter/widgets.dart';
import 'package:oauth2/oauth2.dart' as oauth;
import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:ddish/src/widgets/message.dart' as message;
import 'package:ddish/src/repositiories/globals.dart' as globals;

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends AbstractBloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  bool useFingerprint;
  bool rememberUsername;

  LoginBloc(pageState,
      {@required this.userRepository, @required this.authenticationBloc})
      : assert(authenticationBloc != null),
        super(pageState);

  @override
  LoginState get initialState {
    globals.client = null;
    userRepository
        .isUsernameRemember()
        .then((value) => rememberUsername = value);
    userRepository.useFingerprint().then((value) => useFingerprint = value);
    return LoginInitial();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        ///хэрэглэгч нэвтрэх хүсэлт илгээх
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
          rememberUsername: event.rememberUsername,
          useFingerprint: event.useFingerprint,
          fingerPrintLogin: event.fingerPrintLogin,
        );

        //        authenticationBloc.dispatch(LoggedIn(token: token));
        Navigator.pushNamed(pageState.context, "/Main");
        yield LoginInitial();
      } on oauth.AuthorizationException {
        message.show(event.context, "Нэвтрэх нэр эсвэл нууц үг буруу байна",
            message.SnackBarType.ERROR);
        yield LoginFailure(error: "Bad credentials.");
      } on SocketException catch (e) {
        yield LoginFailure(error: "Network error.");
      }
    } else if (event is ForgotPass) {
      //TODO нууц үг сэргээх зааваргаа бүхий dialog нээх
      //....
    }
  }

  ///хэрэглэгчийн нэрийг шинэчлэх
  updateRememberUsername({rememberUsername}) {
    userRepository.rememberUsername(rememberUsername);
  }

  updateRememberFingerprint({rememberFingerprint}) {
    userRepository.rememberFingerprint(rememberFingerprint);
  }
}
