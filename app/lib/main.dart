import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/authentication/authentication_event.dart';
import 'package:ddish/src/blocs/login/login_bloc.dart';
import 'package:ddish/src/blocs/mixin/bloc_mixin.dart';
import 'package:ddish/src/integration/integration.dart';
import 'package:ddish/src/utils/connectivity.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/templates/login/login_page.dart';
import 'package:ddish/src/templates/main/main_widget.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:oauth2/oauth2.dart';

class SimpleBlocDelegate extends BlocDelegate {

  final Logger log = new Logger('SimpleBlocDelegate');
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.severe(transition);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    log.severe(event);

    if (event is NetworkAccessRequired)
      NetworkConnectivity().checkNetworkConnectivity();
  }
}

void main() async {
  var routes = <String, WidgetBuilder>{
    "/Login": (BuildContext context) => new LoginWidget(),
    "/Main": (BuildContext context) => new MainView(),
  };

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(await initializeApp(routes));
}

Future<Widget> initializeApp(routes) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  Connectivity connectivity = Connectivity();

  //холболтын төлвийг чагнах
  connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
    if (ConnectivityResult.none == result)
      Constants.notificationCheckConnection();
  });

  FirebaseNotifications().setUpFirebase();

  setStatusBarFontColor();

  return MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xFF2a68b8),
      accentColor: Color(0xFF2a68b8),
      dividerColor: Color(0xffffffff),
      fontFamily: 'Montserrat',
    ),
    home: LoginWidget(),
    routes: routes,
  );
}

void setStatusBarFontColor() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, //android
      statusBarIconBrightness: Brightness.light, //android
      statusBarBrightness: Brightness.dark, //ios
    ),
  );
}
