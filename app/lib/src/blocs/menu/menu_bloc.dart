import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  @override
  MenuState get initialState => MenuInitial();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if(event is MenuHidden) {
      yield MenuInitial();
    }
    if (event is MenuNavigationClicked) {
      yield MenuOpened();
    }
    if (event is MenuClicked) {
      yield ChildMenuOpened(menu: event.selectedMenu);
    }
  }
}
