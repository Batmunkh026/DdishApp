import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/login/login_bloc.dart';
import 'package:ddish/src/blocs/mixin/bloc_mixin.dart';
import 'package:ddish/src/utils/connectivity.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/templates/login/login_page.dart';
import 'package:ddish/src/templates/main/main_widget.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;
import 'package:logging/logging.dart';
import 'package:oauth2/oauth2.dart';

class SimpleBlocDelegate extends BlocDelegate {
  Timer sessionExpire;
  final Logger log = new Logger('SimpleBlocDelegate');
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.info(transition);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    Client client = globals.client;
    if (client != null) {
      updateExpireTimeOfLogoutTask(client.credentials.expiration, bloc);

      log.warning("session will expire: ${client.credentials.expiration}}");
      //state өөрчлөгдөх бүрт credential update хийх
      if (client.credentials.canRefresh)
        client
            .refreshCredentials()
            .then((newClient) => globals.client = newClient);
    }
//
    if (event is NetworkAccessRequired)
      NetworkConnectivity().checkNetworkConnectivity();
  }

  void updateExpireTimeOfLogoutTask(DateTime expireTime, Bloc bloc) {
    if (expireTime == null) return;

    if (bloc is AbstractBloc && !(bloc is LoginBloc)) {
      DateTime now = DateTime.now();
      Duration difference = now.isBefore(expireTime)
          ? now.difference(expireTime)
          : Duration(seconds: 0);

      Timer expireTask = Timer(
          Duration(milliseconds: difference.inMilliseconds.abs()),
          () => bloc
              .connectionExpired("session expired on : sessionTimer task"));

      //өмнөх таск ыг цуцлах
      if (sessionExpire != null) sessionExpire.cancel();

      sessionExpire = expireTask;
    }
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
