import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/notification/notification_event.dart';
import 'package:ddish/src/blocs/notification/notification_state.dart';
import 'package:ddish/src/repositiories/notification_repository.dart';
import 'package:flutter/src/widgets/framework.dart';

class NotificationBloc
    extends AbstractBloc<NotificationEvent, NotificationState> {
  NotificationRepository _repository;

  NotificationBloc(State<StatefulWidget> pageState) : super(pageState) {
    _repository = NotificationRepository(this);
  }

  @override
  NotificationState get initialState => Started();

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is LoadEvent) {
      yield Loading();
      _repository
          .getNotifications()
          .then((notifications) => dispatch(LoadedEvent(notifications)));
    } else if (event is LoadedEvent) yield Loaded(event.notifications);
  }
}
