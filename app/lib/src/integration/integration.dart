import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;
import 'package:logging/logging.dart';

class FirebaseNotifications {
  final Logger log = new Logger('FirebaseNotifications');
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();

    firebaseCloudMessaging_Listeners();

    _firebaseMessaging.subscribeToTopic("ddish");
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      globals.FCM_TOKEN = token;
      log.info("FCM_TOKEN = $token");
    });

    _firebaseMessaging.onTokenRefresh
        .listen((newToken) => globals.FCM_TOKEN = newToken);

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
