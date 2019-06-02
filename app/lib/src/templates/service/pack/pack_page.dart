import 'package:ddish/src/blocs/service/pack/pack_bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PackPageState();
}

class PackPageState extends State<PackPage> {
  var packBloc = PackBloc();

  var packTabs = Constants.servicePackTabs;

  get createTabBar => TabBar(
        isScrollable: true,
        tabs: packTabs
            .map((tabItem) => Tab(
                child: Text(tabItem.title,
                    style: TextStyle(color: Color(0xff071f49)))))
            .toList(),
        onTap: (tabIndex) =>
            packBloc.dispatch(PackServiceSelected(packTabs[tabIndex].state)),
        indicatorColor: Color.fromRGBO(48, 105, 178, 1),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: packBloc,
        builder: (context, state) {
          return DefaultTabController(
            length: packTabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: Column(
                  children: <Widget>[
                    new RichText(
                        text: new TextSpan(children: [
                      new TextSpan(
                          style: const TextStyle(
                              color: const Color(0xff071f49),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 8.0),
                          text: "Идэвхтэй багц Дуусах хугацаа: "),
                      new TextSpan(
                          style: const TextStyle(
                              color: const Color(0xff071f49),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 8.0),
                          text: " 09.30.2019")
                    ])),
                    DropdownButton(
                        items:
                            state is ServicePackTabState ? state.packTypes : [],
                        onChanged: (value) =>
                            packBloc.dispatch(PackTypeSelectorClicked(value)))
                  ],
                ),
                backgroundColor: Colors.white,
                bottom: createTabBar,
              ),
              body: Scaffold(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                // TODO Багцын контентуудыг харуулах
              ),
            ),
          );
        });
  }
}
