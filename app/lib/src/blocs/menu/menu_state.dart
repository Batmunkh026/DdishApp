import 'package:equatable/equatable.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:meta/meta.dart';

abstract class MenuState extends Equatable {
  MenuState([List props = const []]) : super(props);
}

class MenuInitial extends MenuState {
  @override
  String toString() => 'menu initial';
}

class MenuOpened extends MenuState {
  final Menu menu;
  MenuOpened({
    @required this.menu,
  });
  @override
  String toString() => 'menu opened: {}';
}