import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/tab/tab.dart';
import 'package:ddish/src/models/tab_models.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  @override
  TabState get initialState => TabState.SERVICE;

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      if(event.tab == TabState.SERVICE){

      }else if(event.tab == TabState.MENU){

      }else if(event.tab == TabState.NOTIFICATION){

      }else
        throw UnsupportedError("дэмжигдэхгүй төлөв: ${event.tab}");
//      yield event.tab;
    }
  }
}
