import 'dart:ui';

import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/login/login_bloc.dart';
import 'package:ddish/src/blocs/login/login_event.dart';
import 'package:ddish/src/blocs/login/login_state.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:ddish/src/widgets/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/utils/input_validations.dart';

import 'style.dart' as style;

class LoginView extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;
  final String username;
  final bool useFingerprint;
  final bool canCheckBiometrics;

  LoginView({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
    this.username,
    this.useFingerprint,
    this.canCheckBiometrics,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  LoginBloc get _loginBloc => widget.loginBloc;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool useFingerprint;
  bool rememberUsername;
  bool canCheckBiometrics;

  @override
  void initState() {
    _usernameController.text = widget.username;
    rememberUsername = widget.username != null;
    useFingerprint = widget.useFingerprint;
    canCheckBiometrics = widget.canCheckBiometrics;
    super.initState();
  }

  @override
  void dispose() {
//    _usernameController.dispose();
//    _passwordController.dispose();
    super.dispose();
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
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 150.0, bottom: 50.0),
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/logo.png'),
                      height: 130.0,
                      width: 130.0,
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InputField(
                          placeholder: 'АДМИН ДУГААР / СМАРТ КАРТЫН ДУГААР',
                          textController: _usernameController,
                          obscureText: false,
                          textInputType: TextInputType.number,
                          validateFunction:
                              InputValidations.validateNumberValue,
                        ),
                        InputField(
                          placeholder: 'НУУЦ ҮГ /****/',
                          textController: _passwordController,
                          obscureText: true,
                          validateFunction:
                              InputValidations.validateNotNullValue,
                        ),
                        FlatButton(
                          onPressed: () => _showDialog(context),
                          padding: EdgeInsets.all(0.0),
                          child: Text(
                            'Нууц үгээ мартсан уу?',
                            style: TextStyle(
                              color: Color(0xffe4f0ff),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: <Widget>[
                        ToggleSwitch(
                          value: rememberUsername,
                          hint: "Нэвтрэх нэр хадгалах",
                          style: style.switchHint,
                          onChanged: (value) => rememberUsername = value,
                        ),
                        Visibility(
                          visible: widget.canCheckBiometrics,
                          child: ToggleSwitch(
                            value: useFingerprint,
                            hint: "Цаашид хурууны хээгээр нэвтэрнэ",
                            style: style.switchHint,
                            onChanged: (value) => useFingerprint = value,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SubmitButton(
                text: "НЭВТРЭХ",
                verticalMargin: 10.0,
                horizontalMargin: 70.0,
                onPressed:
                    state is! LoginLoading ? _onLoginButtonPressed : null,
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

  Future _showDialog(BuildContext context) async {
    List<Widget> actions = new List();
    ActionButton closeDialog = ActionButton(
      title: 'Хаах',
      onTap: () => Navigator.pop(context),
    );
    actions.add(closeDialog);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: Text('Санамж',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xfffcfdfe),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0)),
            content: style.forgotPasswordHint,
            actions: actions,
          );
        });
  }

  _onLoginButtonPressed() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _loginBloc.dispatch(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
        rememberUsername: rememberUsername,
        useFingerprint: useFingerprint,
        fingerPrintLogin: false,
      ));
    }
  }
}
