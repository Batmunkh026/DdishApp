import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;
import 'package:logging/logging.dart';

/// firebase messaging integration
class FirebaseNotifications {
  final Logger log = new Logger('FirebaseNotifications');
  FirebaseMessaging _firebaseMessaging;

  /// firebase messaging service ыг ажиллуулах , эвентүүдийг чагнах
  void setUpFirebase()async {
    _firebaseMessaging = FirebaseMessaging();

    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) => setToken(token));

    _firebaseMessaging.onTokenRefresh
        .listen((newToken) => setToken(newToken, isTokenRefresh: true));

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

  setToken(String token, {isTokenRefresh = false}) {
    log.info("FCM_TOKEN = $token , isRefresh = $isTokenRefresh");

    if (token == null) return;

    /// firebase messagin token авч memory д хадгалах
    globals.FCM_TOKEN = token;

    _firebaseMessaging.subscribeToTopic("ddish");
  }
}
