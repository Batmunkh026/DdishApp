import 'package:ddish/presentation/ddish_flutter_app_icons.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:ddish/src/templates/notification/notification_page.dart';
import 'package:ddish/src/templates/service/service_page.dart';
import 'package:ddish/src/utils/connectivity.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  MainView({Key key}) : super(key: key);

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  int _currentTabIndex = 0;

  MenuPage menuPage;
  ServicePage servicePage;
  NotificationPage notificationPage;

  @override
  void initState() {
    menuPage = MenuPage();
    servicePage = ServicePage();
    notificationPage = NotificationPage();
    super.initState();
  }

  @override
  void dispose() {
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
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/satellite_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: content[_currentTabIndex],
        ),
        bottomNavigationBar: Container(
          height: height * 0.07,
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
        ));
  }

  onNavigationTap(int index) {
    setState(() {
      _currentTabIndex = index;
      NetworkConnectivity().checkNetworkConnectivity();
    });
  }
}
