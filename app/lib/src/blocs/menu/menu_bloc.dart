import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';
import 'package:ddish/src/models/branch.dart';
import 'package:ddish/src/repositiories/menu_repository.dart';
import 'package:flutter/src/widgets/framework.dart';

class MenuBloc extends AbstractBloc<MenuEvent, MenuState> {
  final MenuRepository repository = MenuRepository();

  MenuBloc(State<StatefulWidget> pageState) : super(pageState);

  @override
  MenuState get initialState => MenuInitial();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is MenuHidden) {
      yield MenuInitial();
    }
    if (event is MenuNavigationClicked) {
      yield MenuOpened();
    }
    if (event is MenuClicked) {
      yield ChildMenuOpened(menu: event.selectedMenu);
    }
  }
  Future<List<Branch>> getBranches(String area, String type, String service){
    return repository.fetchBranches(area, type, service);
  }
  Future<BranchParam> getBranchParam(){
    return repository.fetchBranchParams();
  }
  
}
