import 'package:equatable/equatable.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:meta/meta.dart';

abstract class MenuEvent extends Equatable{
  MenuEvent([List props = const []]) : super(props);
}
class MenuClicked extends MenuEvent{
  final Menu selectedMenu;

  MenuClicked({
    @required this.selectedMenu,
  });
  @override
  String toString() => "menu clicked { menu: $selectedMenu }";
}