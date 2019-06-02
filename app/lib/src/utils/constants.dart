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
    TabMenuItem("Данс", Icons.arrow_drop_down, ServiceTabType.ACCOUNT),
    TabMenuItem("Багц", Icons.arrow_drop_down, ServiceTabType.PACK),
    TabMenuItem("Кино", Icons.arrow_drop_down, ServiceTabType.MOVIE),
  ];

  static const servicePackTabs = const[
    TabMenuItem("Сунгах", Icons.arrow_drop_down, PackTabType.EXTEND),
    TabMenuItem("Нэмэлт сувгууд", Icons.arrow_drop_down, PackTabType.ADDITIONAL_CHANNEL),
    TabMenuItem("Ахиулах", Icons.arrow_drop_down, PackTabType.UPGRADE),
  ];
}