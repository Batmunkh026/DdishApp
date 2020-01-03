import 'package:ddish/src/templates/service/movie/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/templates/service/movie/theatre/movie_theatre.dart';
import 'style.dart' as style;

/// Кино мэдээллийн ерөнхий хуудас
class MoviePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoviePageState();
}

class MoviePageState extends State<MoviePage>
    with SingleTickerProviderStateMixin {
  Library library;
  TheatreWidget threatre;

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => FocusScope.of(context).unfocus());
    library = Library();
    threatre = TheatreWidget();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: tabChanged,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        appBar: TabBar(
          controller: _tabController,
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
          controller: _tabController,
          children: <Widget>[
            library,
            threatre,
          ],
        ),
      ),
    );
  }

  void tabChanged(DragUpdateDetails details) {
    double delta = details.delta.dx;
    if (delta != 0.0) {
      bool isRight = delta < 0;

      var currentIndex = _tabController.index;
      if (isRight && currentIndex == 1)
        _tabController.animateTo(2);
      else if (!isRight && currentIndex == 2) _tabController.animateTo(1);
    }
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
