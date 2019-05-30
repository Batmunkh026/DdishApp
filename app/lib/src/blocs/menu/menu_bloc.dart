import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  @override
  MenuState get initialState => MenuInitial();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is MenuInitial) yield MenuInitial();
  }
}
