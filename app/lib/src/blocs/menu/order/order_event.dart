import 'package:ddish/src/models/order.dart';
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  OrderEvent([List props = const []]) : super(props);
}

class OrderTapped extends OrderEvent {
  final Order order;

  OrderTapped({this.order});

  @override
  String toString() => 'order tapped.';
}
