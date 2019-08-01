import 'package:connectivity/connectivity.dart';
import 'package:ddish/src/blocs/mixin/bloc_mixin.dart';
import 'package:ddish/src/integration/integration.dart';
import 'package:ddish/src/utils/connectivity.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/templates/login/login_page.dart';
import 'package:ddish/src/templates/main/main_widget.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
  @override
  void onEvent(Bloc bloc, Object event){
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

  FirebaseNotifications().setUpFirebase();

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