import 'package:ddish/src/blocs/navigation/navigation_bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:ddish/src/templates/service/service_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/templates/login/login_page.dart';

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  NavigationBloc navigationBloc;
  AuthenticationBloc authenticationBloc;

  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    navigationBloc = NavigationBloc();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DDISH"),
        ),
        body: BlocBuilder<NavigationEvent, int>(
          bloc: navigationBloc,
          builder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return MenuPage();
              case 1:
                return ServicePage();
              case 2:
                return Text("NOTIFICATION");
              case 3:
                return LoginPage(userRepository: userRepository);
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.indigoAccent,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.menu),
                  disabledColor: Colors.grey,
                  onPressed: navigationBloc.currentState == 0 ? null : () => onTap(0)),
              Visibility(
                child: IconButton(
                    icon: Icon(Icons.settings_input_antenna),
                    disabledColor: Colors.grey,
                    onPressed: navigationBloc.currentState == 1 ? null : () => onTap(1)),
                visible: authenticationBloc.currentState.toString() == 'AuthenticationAuthenticated',
              ),
              Visibility(
                child: IconButton(
                    icon: Icon(Icons.notifications),
                    disabledColor: Colors.grey,
                    onPressed: navigationBloc.currentState == 2 ? null : () => onTap(2)),
                visible: authenticationBloc.currentState.toString() == 'AuthenticationAuthenticated',
              )
            ],
        )));
  }

  onTap(int index) {
    setState(
        () => navigationBloc.dispatch(NavigationEvent.values.elementAt(index)));
  }
}
