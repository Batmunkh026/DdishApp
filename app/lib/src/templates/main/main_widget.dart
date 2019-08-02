import 'dart:async';

import 'package:ddish/presentation/ddish_flutter_app_icons.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:ddish/src/templates/notification/notification_page.dart';
import 'package:ddish/src/templates/service/service_page.dart';
import 'package:ddish/src/utils/connectivity.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ddish/src/repositiories/globals.dart' as globals;
import 'package:logging/logging.dart';

class MainView extends StatefulWidget {
  final Logger log = new Logger('MainView');
  MainView({Key key}) : super(key: key);

  @override
  State<MainView> createState() => MainViewState();
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
    final double height = MediaQuery.of(context).size.height;
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.23), BlendMode.darken),
                  alignment: Alignment(0.3, 0),
                  image: new AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                child: content[_currentTabIndex],
              ),
            ),
            bottomNavigationBar: Container(
              height: height * 0.08,
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
                      Icons.more_horiz,
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
}
