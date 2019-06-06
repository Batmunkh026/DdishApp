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
}

void main() {
  var routes = <String, WidgetBuilder>{
    "/Login": (BuildContext context) => new LoginWidget(),
    "/Main": (BuildContext context) => new MainView(),
  };

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MaterialApp(
    home: LoginWidget(),
    routes: routes,
  ));
}
