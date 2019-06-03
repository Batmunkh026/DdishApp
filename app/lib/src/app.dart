import 'package:ddish/src/blocs/navigation/navigation_bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:ddish/src/templates/service/service_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/blocs/authentication/authentication_bloc.dart';
import 'package:ddish/src/blocs/authentication/authentication_event.dart';
import 'package:ddish/src/blocs/authentication/authentication_state.dart';
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

  MenuPage menuPage;
  ServicePage servicePage;
  Text notificationText;
  LoginPage loginPage;

  @override
  void initState() {
    navigationBloc = NavigationBloc();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    menuPage = MenuPage(
      navigationBloc: navigationBloc,
    );
    servicePage = ServicePage();
    notificationText = Text("NOTIFICATION");
    loginPage = LoginPage(userRepository: userRepository);
    super.initState();
  }

  @override
  void dispose() {
    navigationBloc.dispose();
    authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [menuPage, servicePage, notificationText, loginPage];
    return BlocProvider<AuthenticationBloc>(
      bloc: authenticationBloc,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/satellite_background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BlocBuilder<NavigationEvent, int>(
                bloc: navigationBloc,
                builder: (BuildContext context, int index) {
                  return content[index];
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(canvasColor: Colors.transparent),
                child: BlocBuilder<AuthenticationEvent, AuthenticationState>(
                  bloc: authenticationBloc,
                  builder: (BuildContext context, AuthenticationState state) {
                    bool loggedIn = state == AuthenticationAuthenticated();
                    onTap(loggedIn ? 1 : 3);
                    if (state is! AuthenticationAuthenticated) {
                      return IconButton(
                        icon: Icon(Icons.more_horiz, color: Colors.grey,),
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.all(20.0),
                        onPressed: () => onTap(0),
                      );
                    } else
                    if (state is AuthenticationAuthenticated) {
                      return BottomAppBar(
                          color: Colors.indigoAccent,
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Visibility(
                                child: IconButton(
                                    icon: Icon(Icons.settings_input_antenna, color: Colors.grey,),
                                    disabledColor: Colors.white,
                                    onPressed: navigationBloc.currentState == 1
                                        ? null
                                        : () => onTap(1)),
                                visible: loggedIn,
                              ),
                              Visibility(
                                child: IconButton(
                                    icon: Icon(Icons.notifications),
                                    disabledColor: Colors.white,
                                    onPressed: navigationBloc.currentState == 2
                                        ? null
                                        : () => onTap(2)),
                                visible: loggedIn,
                              ),
                              IconButton(
                                  icon: Icon(Icons.menu),
                                  disabledColor: Colors.white,
                                  onPressed: navigationBloc.currentState == 0
                                      ? null
                                      : () => onTap(0)),
                            ],
                          ));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onTap(int index) {
    navigationBloc.dispatch(NavigationEvent.values.elementAt(index));
  }

  onBackPress() {
    navigationBloc.dispatch(
        authenticationBloc.currentState == AuthenticationAuthenticated()
            ? NavigationEvent.SERVICE
            : NavigationEvent.INACTIVE);
  }
}
