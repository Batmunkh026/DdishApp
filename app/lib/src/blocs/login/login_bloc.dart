import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:oauth2/oauth2.dart' as oauth;
import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/authentication/authentication_event.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:meta/meta.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc
  })  : assert(authenticationBloc != null);

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
        );

        authenticationBloc.dispatch(LoggedIn(token: token));
        yield LoginInitial();
      } on oauth.AuthorizationException {
        yield LoginFailure(error: "Bad credentials.");
      } on SocketException {
        yield LoginFailure(error: "Network error.");
      }
    }else if(event is ForgotPass){
      //TODO нууц үг сэргээх зааваргаа бүхий dialog нээх
      //....
    }
  }
}