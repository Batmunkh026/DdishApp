import 'package:ddish/src/blocs/service/pack/pack_bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/models/month_price.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/pack_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PackPageState();
}

class PackPageState extends State<PackPage> {
  var packBloc;

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
  void initState() {
    packBloc = PackBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: packBloc,
        builder: (BuildContext context, PackState state) {
          return DefaultTabController(
              length: packTabs.length,
              child: Scaffold(
                appBar: AppBar(
                  title: buildAppBarHeader(context, state),
                  backgroundColor: Colors.white,
                  bottom: createTabBar,
                ),
                body: buildContents(state),
              ));
        });
  }

  Widget buildAppBarHeader(BuildContext context, PackState state) {
    var fontStyle = TextStyle(
        color: const Color(0xff071f49),
        fontWeight: FontWeight.w500,
        fontFamily: "Montserrat",
        fontStyle: FontStyle.normal,
        fontSize: 12.0);

    var packContentContainer = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("Идэвхтэй багц", style: fontStyle),
                new Text("Дуусах хугацаа: ", style: fontStyle),
              ],
            ),
            //TODO хэрэглэгчийн багцын дуусах хугацааг харуулах
            new Text(" 09.30.2019", style: fontStyle),
          ],
        ),
      ],
    );
    if (state is PackTabState || state is PackSelectionState)
      packContentContainer.children.add(createPackPicker(state));

    return packContentContainer;
  }

  DropdownButton createPackPicker(PackState state) {
    List<Pack> items = state.initialItems != null ? state.initialItems : [];

    return DropdownButton(
      items: items
          .map((pack) => DropdownMenuItem<Pack>(
              value: pack,
              child: Container(
                child: Image.network(pack.image),
              )))
          .toList(),
      value: state.selectedPack != null ? state.selectedPack : items.first,
      onChanged: (value) {
        packBloc.dispatch(PackTypeSelectorClicked(value));
      },
    );
  }

  @override
  void dispose() {
    packBloc.dispose();
    super.dispose();
  }

  Widget buildContents(PackState state) {
    if (state is PackTabState || state is PackSelectionState) {
      Pack pack = state.selectedPack;

      var e =(Pack p, MonthAndPriceToExtend mp)=> packBloc.dispatch(PackItemSelected(p, mp));

      var packPicker = PackGridPicker(context, 2, pack, e);
      return packPicker;

//      var contents = pack.packsForMonth.map((pm) {
//        return GestureDetector(child: Center(
//          child: Card(
//            color: Color.fromRGBO(49, 138, 255, 1),
//            child: Padding(
//              padding: EdgeInsets.all(12),
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  Text("${pm.monthToExtend} сар"),
//                  Text("₮ ${pm.price}"),
//                ],
//              ),
//            ),
//          ),
//        ),onTap: packBloc.dispatch(PackItemSelected(pack, pm)),);
//      }).toList();
//
//      return GridView.count(
//        crossAxisCount: 2,
//        children: contents,
//      );
    }
    return Container();
  }
}
