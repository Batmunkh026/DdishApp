import 'package:flutter/material.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:ddish/src/blocs/navigation/navigation_bloc.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var _tabIndex = 0;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("DDISH"),
      ),
      body: StreamBuilder<NavBarItem>(
        stream: navigationBloc.itemStream,
        initialData: navigationBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.MENU:
              return MenuPage();
            case NavBarItem.SERVICE:
              return Text("SERVICE");
            case NavBarItem.NOTIFICATION:
              return Text("NOTIFICATION");
          }
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: navigationBloc.itemStream,
        initialData: navigationBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
            currentIndex: snapshot.data.index,
            onTap: (index) => navigationBloc.onTap(index),
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
          );
        },
      ),
    );
  }
}
