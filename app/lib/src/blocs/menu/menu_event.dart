import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable{
  MenuEvent([List props = const []]) : super(props);
}
class MenuSelectEvent extends MenuEvent{
  @override
  String toString() => "menu selected";
}