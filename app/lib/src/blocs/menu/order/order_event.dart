import 'package:ddish/src/blocs/mixin/bloc_mixin.dart';
import 'package:ddish/src/models/order.dart';
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  OrderEvent([List props = const []]) : super(props);
}

class OrderTapped extends OrderEvent with NetworkAccessRequired {
  final Order order;

  OrderTapped({this.order});

  @override
  String toString() => 'order tapped.';
}

class OrderEdit extends OrderEvent {
  final Order order;

  OrderEdit(this.order);

  @override
  String toString() => 'order edit.';
}
