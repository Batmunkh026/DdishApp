import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';
import 'package:ddish/src/models/branch.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  @override
  MenuState get initialState => MenuInitial();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is MenuHidden) {
      yield MenuInitial();
    } else if (event is MenuNavigationClicked) {
      yield MenuOpened();
    } else if (event is MenuClicked) {
      yield ChildMenuOpened(menu: event.selectedMenu);
    }
  }

  List<Branch> getDemoBranchLocations() {
    List<Branch> branches = [
      Branch(
          47.9176489,
          106.9045286,
          "Цэцэг төв",
          "A",
          "t",
          ["Үйлчилгээ 1", "Үйлчилгээ 2", "Үйлчилгээ 3"],
          "Салбар 1",
          "Ерөнхий сайд А.Амарын гудамж, Ulaanbaatar 14200, Mongolia",
          [
            "Даваа-Баасан: 09:00-19:00",
            "Бямба-Ням: "
                "10:00-18:00"
          ]),
      Branch(
          47.9143551,
          106.9118418,
          "Бөхийн өргөө",
          "B",
          "x",
          ["Үйлчилгээ 1", "Үйлчилгээ 2"],
          "Салбар 2",
          "Тээвэрчидийн Гудамж, Улаанбаатар 14210",
          [
            "Даваа-Баасан: 09:00-19:00",
            "Бямба-Ням: "
                "10:00-18:00"
          ]),
      Branch(
          47.9171697,
          106.9256163,
          "Гандан",
          "C",
          "y",
          ["Үйлчилгээ 1", "Үйлчилгээ 2", "Үйлчилгээ 3"],
          "Салбар 3",
          "Бага тойрог, Улаанбаатар",
          [
            "Даваа-Баасан: 09:00-19:00",
            "Бямба-Ням: "
                "10:00-18:00"
          ]),
      Branch(
          47.9180952,
          106.9190746,
          "100 айл",
          "D",
          "z",
          ["Үйлчилгээ 1"],
          "Салбар 4",
          "Sukhbaatar St 15, Улаанбаатар 14240",
          [
            "Даваа-Баасан: 09:00-19:00",
            "Бямба-Ням: "
                "10:00-18:00"
          ]),
    ];

    return branches;
  }
}
