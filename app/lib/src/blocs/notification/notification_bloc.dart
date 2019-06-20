import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/notification/notification_event.dart';
import 'package:ddish/src/blocs/notification/notification_state.dart';
import 'package:ddish/src/repositiories/notification_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationRepository _repository = NotificationRepository();

  Loaded _loadedState = Loaded([]);

  @override
  NotificationState get initialState {
    _repository.getNotifications().then((notifications) {
      _loadedState.notifications = notifications;
      dispatch(LoadedEvent());
    });

    return Loading();
  }

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is LoadedEvent) yield _loadedState;
  }
}
