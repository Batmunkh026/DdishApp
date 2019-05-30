import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/notification/notification_event.dart';
import 'package:ddish/src/blocs/notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @override
  NotificationState get initialState => NotificationInitial();

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is NotificationInitial) yield NotificationInitial();
  }
}
