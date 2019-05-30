//import 'package:flutter/material.dart';
//
//class TabSelector extends StatelessWidget {
//  final TabState activeTab;
//  final Function(TabState) onTabSelected;
//
//  TabSelector({
//    Key key,
//    @required this.activeTab,
//    @required this.onTabSelected,
//  }) :  assert(onTabSelected != null),
//        assert(activeTab != null),
//        super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return BottomNavigationBar(
//      currentIndex: TabState.values.indexOf(activeTab),
//      onTap: (index) => onTabSelected(TabState.values[index]),
//      items: TabState.values.map((tab) {
//        return BottomNavigationBarItem(
//          icon: Icon(
//            tab == TabState.SERVICE ? Icons.rss_feed : (tab == TabState.NOTIFICATION ? Icons.access_alarm : Icons.menu),
//          ),
//          title: Text(""),
//        );
//      }).toList(),
//    );
//  }
//}