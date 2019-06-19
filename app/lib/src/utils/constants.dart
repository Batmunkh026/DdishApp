import 'package:ddish/src/models/district.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/models/tab_menu.dart';
import 'package:ddish/src/templates/menu/component/branch_location.dart';
import 'package:ddish/src/utils/events.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/templates/menu/menu.dart';
import 'package:ddish/src/templates/menu/order/order_widget.dart';
import 'package:ddish/src/templates/menu/user_info/user_information.dart';

class Constants {
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

  static const productTabs = const[
    TabMenuItem("Сунгах", Icons.arrow_drop_down, ProductTabType.EXTEND),
    TabMenuItem("Нэмэлт сувгууд", Icons.arrow_drop_down, ProductTabType.ADDITIONAL_CHANNEL),
    TabMenuItem("Ахиулах", Icons.arrow_drop_down, ProductTabType.UPGRADE),
  ];

  static const Map<dynamic, String> permissionStrings = {
    ProductTabType.EXTEND: "багцыг",
    ProductTabType.ADDITIONAL_CHANNEL: "нэмэлт сувгийг",
    ProductTabType.UPGRADE: "багцыг",
  };

  static const List<int> extendableMonths = [1,2,3,6,12];

  static String createPermissionContentStr(ProductTabType packTab, contentToBuy, int time, payment){
    return "Та $contentToBuy ${permissionStrings[packTab]} $time сараар $payment ₮ төлөн сунгах гэж байна.";
  }

  static List<Menu> menuItems = <Menu>[
    Menu(
      title: 'Хэрэглэгчийн мэдээлэл',
      screen: UserInformationWidget(),
      secure: true,
    ),
    Menu(
      title: 'Антен тохируулах заавар',
      screen: Container(),
      children: <Menu>[
        Menu(
          title: 'Зурган заавар',
          screen: Container(),
        ),
        Menu(
          title: 'Видео заавар',
          screen: Container(),
        )
      ],
    ),
    Menu(
      title: 'Захиалга өгөх',
      children: <Menu>[
        Menu(
            title: 'Антенн тохируулах захиалга өгөх',
            screen: OrderWidget('15378')),
        Menu(
            title: 'Шинэ хэрэглэгчийн захиалга өгөх',
            screen: OrderWidget('15377'))
      ],
    ),
    Menu(
      title: 'Мэдээ урамшуулал',
      screen: Container(),
    ),
    Menu(
      title: 'Салбарын мэдээлэл',
      screen: BranchLocationView(),
    ),
    Menu(
      title: '7777-1434',
      event: () => Events().callEvent('7777-1434')
    ),
    Menu(
        title: 'Гарах',
        secure: true,
        trailing: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        )),
  ];

  static List<District> districtItems = <District>[
    District(id: 1, name: 'Баянгол дүүрэг'),
    District(id: 2, name: 'Чингэлтэй дүүрэг'),
    District(id: 3, name: 'Хан-Уул дүүрэг'),
    District(id: 4, name: 'Баянзүрх дүүрэг'),
    District(id: 7, name: 'Сонгинохайрхан дүүрэг'),
    District(id: 9, name: 'Сүхбаатар дүүрэг'),
  ];
}