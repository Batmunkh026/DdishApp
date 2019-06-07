import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'style.dart' as style;

class MoviePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoviePageState();
}

class MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: DefaultTabController(
              length: 2,
              child: TabBar(
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                labelStyle: style.activeTabLabelStyle,
                labelColor: const Color(0xff071f49),
                unselectedLabelStyle: style.tabLabelStyle,
                indicatorColor: style.activeTabIndicatorColor,
                tabs: <Widget>[
                  Tab(
                    text: 'Кино сан',
                  ),
                  Tab(
                    text: 'Кино театр',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
