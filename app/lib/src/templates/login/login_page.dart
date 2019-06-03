import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'login.dart';
import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  String username = null;
  bool useFingerprint = null;
  UserRepository get _userRepository => widget.userRepository;
  bool prefsLoaded = false;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: _authenticationBloc,
    );
    readPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return prefsLoaded ? LoginView(
        authenticationBloc: _authenticationBloc,
        loginBloc: _loginBloc,
        username: username,
        useFingerprint: useFingerprint,
    ) : Container();
  }

  readPreferences() async {
    username = await _userRepository.getUsername();
    var value = await _userRepository.useFingerprint();
    useFingerprint = value != null ? value : false;
    if(this.mounted)
      setState(() => prefsLoaded = true);
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}