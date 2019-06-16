import 'package:ddish/src/models/result.dart';
import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  OrderState([List props = const []]) : super(props);
}

class OrderWidgetStarted extends OrderState {
  OrderWidgetStarted();

  @override
  String toString() => 'order widget started.';
}

class OrderRequestProcessing extends OrderState {
  OrderRequestProcessing();

  @override
  String toString() => 'order request processing.';
}

class OrderRequestFinished extends OrderState {
  final Result result;

  OrderRequestFinished({this.result});

  @override
  String toString() => 'order request finished.';
}
