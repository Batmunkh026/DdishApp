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
  PromoTapped();
  @override
  String toString() => 'Promo tapped.';

}

class PromoDetialTapped extends PromoEvent{
  PromoDetialTapped();
  @override
  String toString() => 'Promo detial tapped.';

}