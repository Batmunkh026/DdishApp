import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/login/login_bloc.dart';
import 'package:ddish/src/blocs/login/login_event.dart';
import 'package:ddish/src/blocs/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(authenticationBloc: _authenticationBloc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
          //TODO нэвтрэх оролдлого амжилтгүй болсон үед юу хийх ??
        }

        return Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Хэрэглэгчийн нэр'),
                controller: _usernameController,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Нууц үг'),
                controller: _passwordController,
                obscureText: true,
              ),
              RaisedButton(
                onPressed:
                    state is! LoginLoading ? _onLoginButtonPressed : null,
                child: Text('Нэвтрэх'),
              ),
              Container(
                child:
                    state is LoginLoading ? CircularProgressIndicator() : null,
              ),
            ],
          ),
        );
      },
    );
  }

  _onLoginButtonPressed() {
    _loginBloc.dispatch(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text));
  }
}
