import 'package:ddish/src/blocs/service/pack/pack_bloc.dart';
import 'package:ddish/src/blocs/service/service_bloc.dart';
import 'package:ddish/src/blocs/service/service_event.dart';
import 'package:ddish/src/blocs/service/service_state.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account/account_page.dart';
import 'movie/movie_page.dart';
import 'pack/pack_page.dart';

///Үйлчилгээ ерөнхий цонх
///Үйлчилгээний цонхнуудын ерөнхий шинжүүдийг агуулсан байх ёстой
///жишээ: Үйлчилгээ цонхнууд {Данс, Багц, Кино } гэсэн үндсэн агуулагдсан tab тай байх ёстой
class ServicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ServicePageState();
}

class ServicePageState extends State<ServicePage> {
  ServiceBloc bloc;

  var builder;
  Container tabContainer;
  var serviceTabs = Constants.serviceTabs;
  var servicePackTabState;

  ///Үйлчилгээний үндсэн таб ууд
  TabBar get createTabBar => TabBar(
        isScrollable: true,
        tabs: serviceTabs
            .map((tabItem) => Tab(child: Text(tabItem.title)))
            .toList(),
        onTap: (tabIndex) =>
            bloc.dispatch(ServiceTabSelected(serviceTabs[tabIndex].state)),
        labelStyle: TextStyle(
            color: Color(0xfff9f9f9),
            backgroundColor: Color.fromRGBO(42, 104, 184, 1)),
        indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 0)),
        indicatorColor: Colors.transparent,
        unselectedLabelStyle: TextStyle(color: Color(0xfff9f9f9)),
        unselectedLabelColor: Color(0xfff9f9f9),
      );

  @override
  void initState() {
    bloc = ServiceBloc();

    builder = BlocBuilder(bloc: bloc, builder: createBuilder);
    servicePackTabState =
        bloc.servicePackTabState; //үйлчилгээний багц ын дэд таб ын төлөв
    tabContainer = Container(); //Үйлчилгээ багцын дэд таб ын content container
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return builder;
  }

  Widget createBuilder(BuildContext context, ServiceState state) {
    this.servicePackTabState = state;

    return Container(
      margin: EdgeInsets.fromLTRB(8, 10, 8, 4),
      child: DefaultTabController(
        length: serviceTabs.length,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Үйлчилгээ",
                style: const TextStyle(
                    color: const Color(0xfff8f8f8),
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16)),
            backgroundColor: Colors.transparent,
            bottom: createTabBar,
          ),
          body: Scaffold(
            resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 70.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(20.0),
                ),
                child: TabBarView(children: [AccountPage(), PackPage(), MoviePage()]),
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
