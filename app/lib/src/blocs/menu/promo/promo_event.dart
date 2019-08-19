import 'package:ddish/src/blocs/menu/promo/promo_state.dart';
import 'package:equatable/equatable.dart';

abstract class PromoEvent extends Equatable {
  PromoEvent([List props = const []]) : super(props);
}

class PromoStarted extends PromoEvent {
  PromoStarted();
  @override
  String toString() => "Promo started.";
}

class PromoTapped extends PromoEvent{
  var selectedPromo;

  PromoTapped(this.selectedPromo):super([selectedPromo]);
  @override
  String toString() => 'Promo tapped.';

}

class PromoDetialTapped extends PromoEvent{
  var selectedPromo;
  PromoDetialTapped(this.selectedPromo):super([selectedPromo]);
  @override
  String toString() => 'Promo detial tapped.';

}

class BackToState extends PromoEvent{
}
