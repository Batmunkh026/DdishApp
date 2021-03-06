import 'package:ddish/src/blocs/mixin/bloc_mixin.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ddish/src/templates/menu/menu.dart';

abstract class MenuEvent extends Equatable {
  MenuEvent([List props = const []]) : super(props);
}

class MenuStarted extends MenuEvent{
  @override
  String toString() => "menu started";
}

class MenuHidden extends MenuEvent {
  MenuHidden();

  @override
  String toString() => "menu navigation hidden";
}

class MenuNavigationClicked extends MenuEvent with NetworkAccessRequired {
  MenuNavigationClicked();

  @override
  String toString() => "menu navigation clicked";
}

class MenuClicked extends MenuEvent {
  final Menu selectedMenu;

  MenuClicked({
    @required this.selectedMenu,
  });

  @override
  String toString() => "menu clicked { menu: $selectedMenu }";
}
