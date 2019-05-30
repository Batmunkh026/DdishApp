import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/models/tab_menu.dart';
import 'package:flutter/material.dart';

class Constants{
  static const List<TabMenuItem> mainMenuItems = const <TabMenuItem>[
    TabMenuItem("", Icons.rss_feed, TabState.SERVICE),
    TabMenuItem("", Icons.access_alarms, TabState.NOTIFICATION),
    TabMenuItem("", Icons.menu, TabState.MENU),
  ];

  static const serviceTabs = const[
    TabMenuItem("Данс", Icons.arrow_drop_down, ServiceTab.ACCOUNT),
    TabMenuItem("Багц", Icons.arrow_drop_down, ServiceTab.COLLECTION),
    TabMenuItem("Кино", Icons.arrow_drop_down, ServiceTab.MOVIE),
  ];
}