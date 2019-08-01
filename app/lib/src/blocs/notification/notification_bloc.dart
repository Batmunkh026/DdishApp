import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/notification/notification_event.dart';
import 'package:ddish/src/blocs/notification/notification_state.dart';
import 'package:ddish/src/repositiories/notification_repository.dart';
import 'package:flutter/src/widgets/framework.dart';

class NotificationBloc extends AbstractBloc<NotificationEvent, NotificationState> {
  NotificationRepository _repository;

  Loaded _loadedState = Loaded([]);

  NotificationBloc(State<StatefulWidget> pageState) : super(pageState);

  @override
  NotificationState get initialState {
    _repository = NotificationRepository(this);

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
