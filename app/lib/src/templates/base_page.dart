import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:ddish/src/blocs/notification/notification_bloc.dart';
import 'package:ddish/src/blocs/service/service_bloc.dart';
import 'package:ddish/src/blocs/tab/tab.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/templates/menu/menu_page.dart';
import 'package:ddish/src/templates/notification/notification_page.dart';
import 'package:ddish/src/templates/service/service_page.dart';
import 'package:ddish/src/models/tab_menu.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/tab_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///tab container уудыг агуулсан үндсэн page
class BasePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BasePageState();
}

class BasePageState extends State<BasePage> {
  TabBloc _tabBloc = TabBloc();
  ServiceBloc _serviceBloc;
  NotificationBloc _notificationBloc;
  MenuBloc _menuBloc;

  List<TabMenuItem> tabMenus = Constants.mainMenuItems;

  get getTabs =>
      tabMenus.map((tabItem) => Tab(icon: Icon(tabItem.icon))).toList();

  @override
  void initState() {
    _serviceBloc = ServiceBloc();
    _menuBloc = MenuBloc();
    _notificationBloc = NotificationBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _tabBloc,
      builder: (BuildContext context, TabState currentTab) {
        return BlocProviderTree(
          blocProviders: [
            BlocProvider<TabBloc>(bloc: _tabBloc),
            BlocProvider<ServiceBloc>(bloc: _serviceBloc),
            BlocProvider<NotificationBloc>(bloc: _notificationBloc),
            BlocProvider<MenuBloc>(bloc: _menuBloc),
          ],
          child: MaterialApp(
            home: DefaultTabController(
              length: tabMenus.length,
              child: Scaffold(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                body: TabBarView(
                    children: [ServicePage(), NotificationPage(), MenuPage()]),
                bottomNavigationBar: TabBar(
                  tabs: getTabs,
                  onTap: (tabIndex) => _tabBloc.dispatch(UpdateTab(currentTab)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
//    _tabBloc.dispose();
    _serviceBloc.dispose();
    _notificationBloc.dispose();
    _menuBloc.dispose();
    super.dispose();
  }
}

class MainContainer extends StatefulWidget {
  TabState currentTab;
  TabBloc bloc;

  MainContainer(@required this.currentTab, @required this.bloc)
      : assert(currentTab != null),
        assert(bloc != null);

  @override
  State<StatefulWidget> createState() => MainContainerState();
}

class MainContainerState extends State<MainContainer> {
  List<Tab> get getTabMenus => Constants.mainMenuItems
      .map((item) => Tab(
            icon: Icon(
              item.icon,
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //            body: TabBarView(children: [ServicePage(), NotificationPage(), MenuPage()]),
      body: TabBarView(
          children: Constants.mainMenuItems
              .map((item) => Card(child: Icon(item.icon)))
              .toList()),
//              body: Text("test"),
      bottomNavigationBar: TabSelector(
        activeTab: widget.currentTab,
        onTabSelected: (tab) => widget.bloc.dispatch(UpdateTab(tab)),
      ),
    );
  }
}
