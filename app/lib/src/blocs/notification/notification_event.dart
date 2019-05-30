import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable{
  NotificationEvent([List props = const []]) : super(props);
}

class NotificationReceived extends NotificationEvent{
  @override
  String toString() => "notification received";
}