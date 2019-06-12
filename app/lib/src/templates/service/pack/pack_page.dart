import 'package:ddish/src/blocs/service/pack/pack_bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/models/month_price.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/templates/service/pack/widgets.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
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
              length: packTabs.length, child: buildBody());
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
    if (state is SelectedPackPreview)
      return Text("Сунгах");
    else if (state is PackTabState ||
        state is CustomPackSelector ||
        state is PackSelectionState)
      packContentContainer.children.add(createPackPicker(state));

    return packContentContainer;
  }

  DropdownButton createPackPicker(PackState state) {
//    TODO нэмэлт суваг сонгоход яах ёстойг тодруулах
//    List<dynamic> items = state.initialItems != null ? state.initialItems : [];
    List<dynamic> items = packBloc.packs;

    return DropdownButton(
      items: items
          .map((pack) => DropdownMenuItem<Pack>(
              value: pack,
              child: Container(
                child: Image.network(pack.productId),
              )))
          .toList(),
      //TODO Багц сунгах таб биш бол яах?
      value: state.selectedTab == PackTabType.ADDITIONAL_CHANNEL ||
              state.selectedPack == null ||
              !(state.selectedPack is Pack)
          ? items.first
          : state.selectedPack,
      onChanged: (value) {
        if (state.selectedTab == PackTabType.EXTEND) //TODO сонгосон таб нь [НЭМЭЛТ СУВАГ || АХИУЛАХ] бол яах ёстой ??
          packBloc.dispatch(PackTypeSelectorClicked(state.selectedTab, value));
      },
    );
  }

  @override
  void dispose() {
    packBloc.dispose();
    super.dispose();
  }

  Widget buildContents() {
    var _state = packBloc.currentState;
    if (_state is PackPaymentState) {
      //Багц сунгах төлбөр төлөлтийн үр дүн
      ActionButton chargeAccountBtn =
          ActionButton(title: 'Цэнэглэх', onTap: () {});
      ActionButton closeDialog = ActionButton(title: 'Болих', onTap: () {});

      var paymentResultDialog = CustomDialog(
        title: 'Анхааруулга',
//        TODO мэдэгдлийг хаа нэгтээ хадгалаад авч харуулах. хаана ???
//        content: Text(Constants.paymentStates[_state.paymentState].values),
        actions: [chargeAccountBtn, closeDialog],
      );
    } else if (_state is PackTabState || _state is PackSelectionState) {
      //багц сунгах бол сонгосон багцыг , бусад таб бол боломжит бүх багцуудыг
      var itemsForGrid = _state.selectedTab == PackTabType.EXTEND
          ? _state.selectedPack
          : _state.initialItems;
      var packPicker = PackGridPicker(packBloc, itemsForGrid);
      return packPicker;
    } else if (_state is AdditionalChannelState) {
      //нэмэлт суваг сонгосон төлөв
      return PackGridPicker(packBloc, _state.selectedChannel);
    } else if (_state is SelectedPackPreview) {
      return PackPaymentPreview(packBloc);
    } else if (_state is CustomPackSelector) {
      return CustomPackChooser(packBloc);
    } else
      throw UnsupportedError("Тодорхойгүй state: $_state");
  }

  AppBar buildAppBar() {
    var _state = packBloc.currentState;
    if (_state is SelectedPackPreview)
      return AppBar(
        backgroundColor: Colors.white,
        title: buildAppBarHeader(context, _state),
//        backgroundColor: Colors.white,
      );

    return AppBar(
      title: buildAppBarHeader(context, _state),
      backgroundColor: Colors.white,
      bottom: createTabBar,
    );
  }

  Widget buildBody() {
    if (packBloc.currentState is SelectedPackPreview) return buildContents();

    return Scaffold(
      appBar: buildAppBar(),
      body: buildContents(),
    );
  }
}
