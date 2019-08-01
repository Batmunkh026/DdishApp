import 'package:ddish/src/blocs/mixin/bloc_mixin.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable{
  NotificationEvent([List props = const []]) : super(props);
}

class LoadedEvent extends NotificationEvent with NetworkAccessRequired {
  @override
  String toString() => "loaded";
}