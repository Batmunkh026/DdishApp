import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ddish/src/templates/menu/menu.dart';

abstract class MenuState extends Equatable {
  MenuState([List props = const []]) : super(props);
}

class MenuInitial extends MenuState {
  @override
  String toString() => 'menu initial';
}

class MenuOpened extends MenuState {
  MenuOpened();

  @override
  String toString() => 'menu opened: {}';
}

class ChildMenuOpened extends MenuState {
  final Menu menu;

  ChildMenuOpened({
    @required this.menu,
  });

  @override
  String toString() => 'sub menu opened: {}';
}
