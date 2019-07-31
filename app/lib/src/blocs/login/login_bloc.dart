import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:oauth2/oauth2.dart' as oauth;
import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/authentication/authentication_event.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:ddish/src/widgets/message.dart' as message;

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends AbstractBloc<LoginEvent, LoginState>{
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc(pageState, {
    @required this.userRepository,
    @required this.authenticationBloc
  }): assert(authenticationBloc != null), super(pageState);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
          rememberUsername: event.rememberUsername,
          useFingerprint: event.useFingerprint,
          fingerPrintLogin: event.fingerPrintLogin,
        );

        authenticationBloc.dispatch(LoggedIn(token: token));
        yield LoginInitial();
      } on oauth.AuthorizationException {
        message.show(event.context, "Нэвтрэх нэр эсвэл нууц үг буруу байна",
            message.SnackBarType.ERROR);
        yield LoginFailure(error: "Bad credentials.");
      } on SocketException catch(e){
        yield LoginFailure(error: "Network error.");
      }
    }else if(event is ForgotPass){
      //TODO нууц үг сэргээх зааваргаа бүхий dialog нээх
      //....
    }
  }
}