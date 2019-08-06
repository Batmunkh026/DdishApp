import 'dart:io';

import 'package:ddish/src/repositiories/notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;
import 'package:logging/logging.dart';

class FirebaseNotifications {
  final Logger log = new Logger('FirebaseNotifications');
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();

    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) => globals.client
        .get("${globals.serverEndpoint}/regClientToken/$token")
        .then((response) => log.info("registering FCM token : ${response.body}")));

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
