import 'package:ddish/src/templates/service/movie/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/templates/service/movie/theatre/movie_theatre.dart';
import 'style.dart' as style;

class MoviePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoviePageState();
}

class MoviePageState extends State<MoviePage> {
  Library library;
  TheatreWidget threatre;

  @override
  void initState() {
    library = Library();
    threatre = TheatreWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: TabBar(
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
        body: TabBarView(
          children: <Widget>[
            library,
            threatre,
          ],
        ),
      ),
    );
  }
}
