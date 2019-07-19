import 'package:ddish/src/models/promo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PromoState extends Equatable{}

class PromoWidgetStarted extends PromoState{
  PromoWidgetStarted();
  @override
  String toString() => 'Promo widget started.';
}
class PromoWidgetLoading extends PromoState{
  @override
  String toString() => 'Promo widget loading.';
}
class PromoWidgetLoaded extends PromoState{
  final List<NewPromoMdl> promoList;
  PromoWidgetLoaded({@required this.promoList});
  @override
  String toString() => 'Promo widget finished.';
}
class PromoWidgetTapped extends PromoState{
  PromoWidgetTapped();
  @override
  String toString() => 'Promo opened.';
}
class PromoWidgetDetialTapped extends PromoState{
  PromoWidgetDetialTapped();
  @override
  String toString() => 'Promo opened.';
}