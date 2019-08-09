import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/authentication/authentication_event.dart';
import 'package:ddish/src/blocs/authentication/authentication_state.dart';
import 'package:ddish/src/blocs/login/login_bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:ddish/src/templates/service/service_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

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
              child: Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.27), BlendMode.darken),
                    alignment: Alignment(0.3, 0),
                    image: new AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
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
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.grey,
                ),
                disabledColor: Colors.white,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(20.0),
                onPressed: () => onMenuTap(),
              ),
            ),
            BlocBuilder<AuthenticationEvent, AuthenticationState>(
              bloc: authenticationBloc,
              builder: (BuildContext context, AuthenticationState state) {
                if (state is AuthenticationAuthenticated) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushNamed(context, "/Main");
                  });
                  authenticationBloc.dispatch(
                      AuthenticationFinished()); // to reset the state and avoid an infinite loop
                }
                return Container();
              },
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
    var localAuth = LocalAuthentication();
    canCheckBiometrics = await localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();
      canCheckBiometrics =
          availableBiometrics.contains(BiometricType.fingerprint);
    }
    username = await userRepository.getUsername();
    var fingerprintLogin = await userRepository.useFingerprint();
    useFingerprint = fingerprintLogin != null ? fingerprintLogin : false;
    if (this.mounted) setState(() => prefsLoaded = true);
  }
}
