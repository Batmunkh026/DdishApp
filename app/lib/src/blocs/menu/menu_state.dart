import 'package:equatable/equatable.dart';

abstract class MenuState extends Equatable {
  MenuState([List props = const []]) : super(props);
}

class MenuInitial extends MenuState {
  @override
  String toString() => 'menu initial';
}