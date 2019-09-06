import 'dart:async';
import 'dart:convert';
import 'package:ddish/presentation/ddish_flutter_app_icons.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:ddish/src/templates/notification/notification_page.dart';
import 'package:ddish/src/templates/service/service_page.dart';
import 'package:ddish/src/utils/connectivity.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;
import 'package:logging/logging.dart';
import 'package:oauth2/oauth2.dart';

class MainView extends StatefulWidget {
  final Logger log = new Logger('MainView');
  MainView({Key key}) : super(key: key) {
    registerFCMToken();
  }

  @override
  State<MainView> createState() => MainViewState();

  void registerFCMToken() {
    if (globals.client == null || globals.FCM_TOKEN == null) return;

    var body = {"clientToken": globals.FCM_TOKEN};

    globals.client
        .post("${globals.serverEndpoint}/regClientToken", body: body)
        .then((response) {
      try {
        var responseJson = json.decode(response.body);
        log.info("registering FCM token : ${responseJson}");
      } catch (e) {
        log.warning(e);
      }
    });
  }
}

class MainViewState extends State<MainView> with WidgetsBindingObserver {
  int _currentTabIndex = 0;

  MenuPage menuPage;
  ServicePage servicePage;
  NotificationPage notificationPage;

  @override
  void initState() {
    menuPage = MenuPage();
    servicePage = ServicePage();
    notificationPage = NotificationPage();
    WidgetsBinding.instance.addObserver(this);

    GestureBinding.instance.pointerRouter
        .addGlobalRoute(_globalUserInteractionHandler);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var client = globals.client;
    //app resume үед session expired бол logout
    if (state == AppLifecycleState.resumed &&
        client != null &&
        client.credentials.isExpired) {
      widget.log.warning("session expired on AppLifecycleState : $state");
      Navigator.of(context).pushNamedAndRemoveUntil("/Login", (_) => false);
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      servicePage,
      notificationPage,
      menuPage,
    ];
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Stack(
              children: [
                Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      alignment: Alignment(0.3, 0),
                      image: new AssetImage("assets/background.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: Color.fromRGBO(19, 43, 83, 0.75),
                ),
                SafeArea(
                  minimum: _currentTabIndex == 2
                      ? EdgeInsets.only(bottom: 16, top: 16)
                      : EdgeInsets.all(16),
                  child: Container(
                    child: content[_currentTabIndex],
                  ),
                )
              ],
            ),
            bottomNavigationBar: Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: BottomNavigationBar(
                currentIndex: _currentTabIndex,
                backgroundColor: Color(0xFF2a68b8),
                selectedItemColor: Colors.white,
                onTap: (index) => onNavigationTap(index),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      DdishAppIcons.satellite,
                    ),
                    title: SizedBox.shrink(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      DdishAppIcons.notifications,
                    ),
                    title: SizedBox.shrink(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      //TODO more icon сонгох
                      Icons.more_horiz, size: 35,
                    ),
                    title: SizedBox.shrink(),
                  )
                ],
              ),
            )),
        onWillPop: _onWillPop);
  }

  onNavigationTap(int index) {
    setState(() {
      _currentTabIndex = index;
      NetworkConnectivity().checkNetworkConnectivity();
    });
  }

  Future<bool> _onWillPop() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            content: Text(
              "Та гарахдаа итгэлтэй байна уу",
              style: TextStyle(color: Colors.white),
            ),
            submitButtonText: "Тийм",
            onSubmit: () => Navigator.of(context).pushNamedAndRemoveUntil(
                "/Login", (Route<dynamic> route) => false),
            closeButtonText: "Үгүй",
          );
        });
    return false;
  }

  _globalUserInteractionHandler(PointerEvent event) {
    _updateUserCredentials();
  }

  /// interactionSkipTime - өгөгдсөн хугацааны доторхи user interaction ыг алгасна
  ///
  //////10 секунд гэж өгсөн бол хэрэглэгчийн 10 секундын доторхи үйлдлүүдэд
  // 1 удаа sesion_time_out хугацааг шинэчилнэ.
  //TODO хэр хугацааны давтамжтай update хийх эсэхийг тодруулах ?
  int interactionSkipTime = 20; //секундээр
  DateTime started = DateTime.now();

  ///Хэрэглэгчийн нэвтэрсэн session хугацааг шинэчлэх
  ///
  /// хэрэглэгчийн апп дотор бүх үйлдэлд дуудагдана.
  ///
  _updateUserCredentials() {
    Client client = globals.client;
    if (client != null) {
      var diff = DateTime.now().difference(started).inSeconds;
      bool isUpdateable = diff > 0 && diff > interactionSkipTime;

      if (isUpdateable) {
        widget.log.warning(
            "session will expire: ${client.credentials.expiration}} , started: $started , diff: $diff,  isUpdateable: $isUpdateable , interactionSkipTime: $interactionSkipTime");
        started = DateTime.now();
      }
      //credentials ны update хийгдсэн хугацааг шалгах
      if (client.credentials.canRefresh && isUpdateable)
        client.refreshCredentials().then((newClient) {
          globals.client = newClient;

          widget.log.warning(
              "updated: NEW EXPIRE DATE >> : ${newClient.credentials.expiration}");
          updateExpireTimeOfLogoutTask(newClient.credentials.expiration);
        });
    }
  }

  Timer sessionExpire;
  void updateExpireTimeOfLogoutTask(DateTime expireTime) {
    if (expireTime == null) return;

    DateTime now = DateTime.now();
    Duration difference = now.isBefore(expireTime)
        ? now.difference(expireTime)
        : Duration(seconds: 0);

    Timer expireTask =
        Timer(Duration(milliseconds: difference.inMilliseconds.abs()), () {
      //session expired үед
      if (expireTime ==
          globals.client.credentials
              .expiration) //credentials нь шинэчлэгдсэн эсэх?

        Navigator.of(context).pushNamedAndRemoveUntil("/Login", (_) => false);
      widget.log.warning("SESSION EXPIRED!");
    });

    //өмнөх таск ыг цуцлах
    if (sessionExpire != null) sessionExpire.cancel();

    sessionExpire = expireTask;
  }
}
