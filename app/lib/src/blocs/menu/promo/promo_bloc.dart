import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/menu/promo/promo_event.dart';
import 'package:ddish/src/blocs/menu/promo/promo_state.dart';
import 'package:ddish/src/models/promo.dart';
import 'package:ddish/src/repositiories/promo_repository.dart';

class PromoBloc extends AbstractBloc<PromoEvent, PromoState> {
  final PromoRepository repository;
  PromoBloc(pageState, {this.repository}) : super(pageState);

  Set<PromoEvent> events = Set();

  var _prevEvent;
  var _currentEvent;

  @override
  PromoState get initialState => PromoWidgetStarted();

  bool get hasBackState => events.length != 0;

  @override
  Stream<PromoState> mapEventToState(PromoEvent event) async* {
    if (event is PromoStarted) {
      yield PromoWidgetLoading();
      List<NewPromoMdl> promos = await repository.fetchNewPromorion();
      registerEvent(event);
      yield PromoWidgetLoaded(promoList: promos);
    } else if (event is PromoTapped) {
      var state = PromoWidgetTapped(event.selectedPromo);
      registerEvent(event);
      yield state;
    } else if (event is PromoDetialTapped) {
      var state = PromoWidgetDetialTapped(event.selectedPromo);
      registerEvent(event);
      yield state;
    } else if (event is BackToState) {
      registerEvent(event);
      var backEvent = events.last;
      events.remove(backEvent);
      dispatch(backEvent);
    }
  }

  void registerEvent(PromoEvent event) {
      _prevEvent = _currentEvent;
      _currentEvent = event;
      if (_prevEvent != null && !(_prevEvent is BackToState) && !(_currentEvent is BackToState)) {
        events.add(_prevEvent);
        print("registered event: $_prevEvent");
      }
  }
}
