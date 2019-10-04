import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:ddish/src/blocs/service/service_bloc.dart';
import 'package:ddish/src/blocs/service/service_event.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account/account_page.dart';
import 'movie/movie_page.dart';
import 'product/product_page.dart';

///Үйлчилгээ ерөнхий цонх
///Үйлчилгээний цонхнуудын ерөнхий шинжүүдийг агуулсан байх ёстой
///жишээ: Үйлчилгээ цонхнууд {Данс, Багц, Кино } гэсэн үндсэн агуулагдсан tab тай байх ёстой
class ServicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ServicePageState();
}

class ServicePageState extends State<ServicePage>
    with TickerProviderStateMixin {
  ServiceBloc bloc;

  Container tabContainer;
  var serviceTabs = Constants.serviceTabs;
  TabController _tabController;

  TabBar tabBar;
  double titleContainerHeight = 0;
  double contentContainerHeight = 0;

  double _contentContainerPadding = 10;

  @override
  void initState() {
    bloc = ServiceBloc(this);
    _tabController = TabController(length: serviceTabs.length, vsync: this);
    _tabController.addListener(() => FocusScope.of(context).unfocus());
    bloc.tabController = _tabController;
    tabContainer = Container(); //Үйлчилгээ багцын дэд таб ын content container

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (contentContainerHeight == 0) {
      double screenHeight = MediaQuery.of(context).size.height;
      double bottomBarHeight = screenHeight * 0.09;
      //not initialized
      tabBar = createTabBar;
      double tabBarHeight = tabBar.preferredSize.height;
      titleContainerHeight = screenHeight * 0.05;

      contentContainerHeight = screenHeight -
          titleContainerHeight -
          tabBarHeight -
          bottomBarHeight -
          screenHeight * 0.11;

      titleContainerHeight =
          titleContainerHeight + _contentContainerPadding * 1.5;
    }

    return BlocProvider(bloc: bloc, child: createBuilder(context));
  }

  Widget createBuilder(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  "Үйлчилгээ",
                  style: TextStyle(
                    color: Color(0xfff8f8f8),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
          tabBar,
          Container(
            padding: EdgeInsets.all(_contentContainerPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(20.0),
            ),
            child: SizedBox(
              height: contentContainerHeight,
              child: TabBarView(
                controller: _tabController,
                children: [
                  AccountPage(contentContainerHeight),
                  ProductPage(contentContainerHeight),
                  MoviePage()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Үйлчилгээний үндсэн таб ууд
  TabBar get createTabBar => TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 30.0),
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: true,
        controller: _tabController,
        tabs: serviceTabs
            .map((tabItem) => Tab(
                  text: tabItem.title,
                ))
            .toList(),
        onTap: (tabIndex) =>
            bloc.dispatch(ServiceTabSelected(serviceTabs[tabIndex].state)),
        labelStyle: TextStyle(
          color: Color(0xfff9f9f9),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 15,
        ),
        indicator: BubbleTabIndicator(
            indicatorColor: Color(0xff2a68b8),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0)),
        indicatorColor: Colors.transparent,
        unselectedLabelStyle: TextStyle(color: Color(0xfff9f9f9)),
        unselectedLabelColor: Color(0xfff9f9f9),
      );

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
