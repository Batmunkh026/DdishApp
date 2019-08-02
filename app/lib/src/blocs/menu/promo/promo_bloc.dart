import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/menu/promo/promo_event.dart';
import 'package:ddish/src/blocs/menu/promo/promo_state.dart';
import 'package:ddish/src/models/promo.dart';
import 'package:ddish/src/repositiories/promo_repository.dart';


class PromoBloc extends AbstractBloc<PromoEvent, PromoState>{
  final PromoRepository repository;
  PromoBloc(pageState, {this.repository}):super(pageState);

  @override
  PromoState get initialState => PromoWidgetStarted();

  @override
  Stream<PromoState> mapEventToState(PromoEvent event) async*{
    if(event is PromoStarted){
      yield PromoWidgetLoading();
      List<NewPromoMdl> promos = await repository.fetchNewPromorion();
      yield PromoWidgetLoaded(promoList: promos);
    }
    if(event is PromoTapped){
      yield PromoWidgetTapped();
    }
    if(event is PromoDetialTapped){
      yield PromoWidgetDetialTapped();
    }
  }
}