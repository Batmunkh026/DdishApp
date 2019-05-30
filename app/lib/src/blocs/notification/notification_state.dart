import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  NotificationState([List props = const []]) : super(props);
}

class NotificationInitial extends NotificationState {
  @override
  String toString() => 'notification initial';
}