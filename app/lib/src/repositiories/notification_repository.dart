import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/models/notification.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;

import 'abstract_repository.dart';

class NotificationRepository extends AbstractRepository {
  final client = globals.client;

  NotificationRepository(AbstractBloc bloc) : super(bloc);

  /// мэдэгдлүүдийг серверээс авах
  Future<List<Notification>> getNotifications() async {
    var _notificationReponse = await getResponse('notification') as Map;

    if (_notificationReponse["isSuccess"] != null &&
        _notificationReponse["isSuccess"])
      return List<Notification>.from(_notificationReponse["notifications"]
          .map((product) => Notification.fromJson(product)));

    return [];
  }
}
