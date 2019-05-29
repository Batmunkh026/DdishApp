import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';

import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/authentication/authentication_state.dart';
import 'package:ddish/src/blocs/authentication/authentication_event.dart';
import 'package:ddish/src/templates/login/login_page.dart';
import 'package:ddish/src/templates/main/main.dart';

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;
  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return new Container();
            }
            if (state is AuthenticationAuthenticated) {
              return MovieListWidget();
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginPage(userRepository: userRepository);
            }
            if (state is AuthenticationLoading) {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}