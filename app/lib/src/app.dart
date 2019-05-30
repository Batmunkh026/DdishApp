import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:ddish/src/blocs/navigation/navigation_bloc.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:ddish/src/templates/service/service_page.dart';

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  NavigationBloc navigationBloc;

  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    navigationBloc = NavigationBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//        stream: navigationBloc.itemStream,
//        initialData: navigationBloc.defaultItem,
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
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationBloc.currentState,
        onTap: (index) => setState(() => navigationBloc.dispatch(NavigationEvent.values.elementAt(index))),
        backgroundColor: Colors.indigoAccent,
        unselectedItemColor: Colors.black26,
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu), title: SizedBox.shrink()),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_input_antenna),
              title: SizedBox.shrink()),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), title: SizedBox.shrink()),
        ],
      ),
    );
  }
}
