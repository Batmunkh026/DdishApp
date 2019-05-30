import 'dart:async';
import 'package:bloc/bloc.dart';

enum NavigationEvent { MENU, SERVICE, NOTIFICATION }

class NavigationBloc extends Bloc<NavigationEvent, int> {
  @override
  int get initialState => 3;

  @override
  Stream<int> mapEventToState(NavigationEvent event) async* {
    yield event.index;
  }
}
