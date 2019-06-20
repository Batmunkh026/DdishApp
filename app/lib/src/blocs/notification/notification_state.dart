import 'package:equatable/equatable.dart';
import 'package:ddish/src/models/notification.dart';

abstract class NotificationState extends Equatable {
  NotificationState([List props = const []]) : super(props);
}

class Loading extends NotificationState {
  @override
  String toString() => 'loading...';
}

class Loaded extends NotificationState {
  List<Notification> notifications = [];

  Loaded(this.notifications);

  @override
  String toString() => 'loaded items size = ${notifications.length}';
}
