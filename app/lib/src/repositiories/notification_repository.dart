import 'dart:convert';

import 'package:ddish/src/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:ddish/src/repositiories/globals.dart' as globals;

class NotificationRepository {
  final client = globals.client;

  Future<List<Notification>> getNotifications() async {
    try {
      final _response =
          await client.read('${globals.serverEndpoint}/notification');
      var _notificationReponse = json.decode(_response) as Map;

      if (_notificationReponse["isSuccess"])
        return List<Notification>.from(_notificationReponse["notifications"]
            .map((product) => Notification.fromJson(product)));

      return [];
    } on http.ClientException catch (e) {
      // TODO catch SocketException
      throw (e);
    }
  }
}
