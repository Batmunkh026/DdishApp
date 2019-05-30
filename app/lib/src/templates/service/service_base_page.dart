import 'package:ddish/src/blocs/service/service_bloc.dart';
import 'package:ddish/src/blocs/service/service_event.dart';
import 'package:ddish/src/templates/base_page.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Үйлчилгээ ерөнхий цонх
///Үйлчилгээний цонхнуудын ерөнхий шинжүүдийг агуулсан байх ёстой
///жишээ: Үйлчилгээ цонхнууд {Данс, Багц, Кино } гэсэн үндсэн агуулагдсан tab тай байх ёстой
class ServiceBasePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ServiceBasePageState();
}

class ServiceBasePageState extends State<ServiceBasePage> {
  ServiceBloc _serviceBloc;
  var serviceTabs = Constants.serviceTabs;

  TabBar get createTabBar => TabBar(
        tabs: serviceTabs
            .map((tabItem) => Tab(child: Text(tabItem.title)))
            .toList(),
        onTap: (tabIndex) =>
            _serviceBloc.dispatch(TabSelected(serviceTabs[tabIndex].state)),
      );

  @override
  void initState() {
    _serviceBloc = BlocProvider.of<ServiceBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Container bodyContainer = Container(
      color: Colors.white54,
    );

    return Container(
      child: DefaultTabController(
        length: serviceTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Үйлчилгээ"),
            bottom: createTabBar,
          ),
          body: bodyContainer,
        ),
      ),
    );
  }
}
