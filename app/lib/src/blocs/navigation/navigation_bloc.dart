import 'dart:async';

enum NavBarItem { MENU, SERVICE, NOTIFICATION }

class NavigationBloc {
  final StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.MENU;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void onTap(int index) {
    switch (index) {
      case 0:
        _navBarController.sink.add(NavBarItem.MENU);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.SERVICE);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.NOTIFICATION);
        break;
    }
  }

  close() {
    _navBarController?.close();
  }
}
