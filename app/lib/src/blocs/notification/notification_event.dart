import 'package:ddish/src/blocs/mixin/bloc_mixin.dart';
import 'package:ddish/src/models/notification.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  NotificationEvent([List props = const []]) : super(props);
}

class LoadEvent extends NotificationEvent with NetworkAccessRequired {
  @override
  String toString() => "loading notifications";
}

class LoadedEvent extends NotificationEvent {
  List<Notification> notifications;
  LoadedEvent(this.notifications) : super([notifications]);

  @override
  String toString() => "loaded";
}
