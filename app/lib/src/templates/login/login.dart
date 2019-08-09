import 'dart:ui';

import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/login/login_bloc.dart';
import 'package:ddish/src/blocs/login/login_event.dart';
import 'package:ddish/src/blocs/login/login_state.dart';
import 'package:ddish/src/utils/input_validations.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:ddish/src/widgets/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool canCheckBiometrics;

  @override
  void initState() {
    _usernameController.text = widget.username;
    useFingerprint = widget.useFingerprint;
    canCheckBiometrics = widget.canCheckBiometrics;
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: width * 0.8,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: Column(
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/logo.png'),
                            width: width * 0.25,
                          ),
                        ],
                      ),
                    ),
                    InputField(
                      placeholder: 'АДМИН ДУГААР / СМАРТ КАРТЫН ДУГААР',
                      textController: _usernameController,
                      obscureText: false,
                      textInputType: TextInputType.number,
                      validateFunction: InputValidations.validateNumberValue,
                    ),
                    InputField(
                      placeholder: 'НУУЦ ҮГ /****/',
                      textController: _passwordController,
                      obscureText: true,
                      validateFunction: InputValidations.validateNotNullValue,
                    ),
                    Center(
                      child: Container(
                        child: state is LoginLoading
                            ? CircularProgressIndicator()
                            : null,
                      ),
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
                    ToggleSwitch(
                      value: _loginBloc.rememberUsername,
                      hint: "Нэвтрэх нэр хадгалах",
                      style: style.switchHint,
                      onChanged: (value) {
                        setState(() {
                          _loginBloc.rememberUsername = value;
                          _loginBloc.updateSharedStoreValue(rememberUsername: value);
                        });
                      },
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
                    Center(
                      child: SubmitButton(
                        text: "НЭВТРЭХ",
                        verticalMargin: 10.0,
                        horizontalMargin: 70.0,
                        onPressed: state is! LoginLoading
                            ? _onLoginButtonPressed
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future _showDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Санамж',
            content: style.forgotPasswordHint,
            closeButtonText: 'Хаах',
          );
        });
  }

  _onLoginButtonPressed() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _loginBloc.dispatch(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
        rememberUsername: _loginBloc.rememberUsername,
        useFingerprint: useFingerprint,
        fingerPrintLogin: false,
        context: context,
      ));
    }
  }
}
