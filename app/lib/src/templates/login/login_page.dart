import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/login/login_bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:ddish/src/templates/service/service_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<LoginWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  AuthenticationBloc authenticationBloc;
  LoginBloc loginBloc;

  UserRepository userRepository;

  ServicePage servicePage;
  Text notificationText;
  String username = '';
  bool useFingerprint = false;
  bool prefsLoaded = false;
  Widget content;
  bool menuOpened = false;
  bool canCheckBiometrics = false;

  @override
  void initState() {
    userRepository = UserRepository(loginBloc);
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    loginBloc = LoginBloc(this,
        userRepository: userRepository, authenticationBloc: authenticationBloc);
    servicePage = ServicePage();
    notificationText = Text("NOTIFICATION");
    readPreferences();
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
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Stack(
                children: [
                  Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        alignment: Alignment(0.3, 0),
                        image: new AssetImage("assets/background.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    color: Color.fromRGBO(19, 43, 83, 0.75),
                  ),
                  Container(
                    child: prefsLoaded
                        ? (menuOpened
                            ? MenuPage(
                                onBackButtonTap: () => onMenuTap(),
                              )
                            : LoginView(
                                authenticationBloc: authenticationBloc,
                                loginBloc: loginBloc,
                                username: username,
                                useFingerprint: useFingerprint,
                                canCheckBiometrics: canCheckBiometrics,
                              ))
                        : Container(),
//                  color: Color.fromRGBO(23, 43, 77, 0.8),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  size: 35,
                  color: menuOpened ? Colors.white : Colors.grey,
                ),
                disabledColor: Colors.white,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(20.0),
                onPressed: () => onMenuTap(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onMenuTap() {
    setState(() {
      menuOpened = !menuOpened;
    });
  }

  readPreferences() async {
    username = await userRepository.getUsername();
    var fingerprintLogin = await userRepository.useFingerprint();
    useFingerprint = fingerprintLogin != null ? fingerprintLogin : false;
    if (this.mounted) setState(() => prefsLoaded = true);
  }
}
