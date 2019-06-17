import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/pack/pack_bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/templates/service/pack/widgets.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PackPageState();
}

class PackPageState extends State<PackPage> {
  PackBloc packBloc;

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
        fontStyle: FontStyle.normal,
        fontSize: 12.0);

    var packContentContainer = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("Идэвхтэй багц", style: fontStyle),
                  new Text("Дуусах хугацаа: ", style: fontStyle),
                ],
              ),
              //TODO хэрэглэгчийн багцын дуусах хугацааг харуулах
              //TODO хэрэглэгч олон идэвхитэй багцтай бол аль багцын дуусах хугацааг харуулах???
              new Text("${DateUtil.formatProductDate(packBloc.user.activeProducts.products.last.endDate)}",
                  style: fontStyle),
            ],
          ),
        ),
      ],
    );
    if (state is SelectedPackPreview)
      return Text("Сунгах");
    else if (state is PackTabState ||
        state is CustomPackSelector ||
        state is PackSelectionState)
      packContentContainer.children.add(createPackPicker(state));

    return Container(
      padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
      child: packContentContainer,
    );
  }

  Widget createPackPicker(PackState state) {
//    TODO нэмэлт суваг сонгоход яах ёстойг тодруулах
//    List<dynamic> items = state.initialItems != null ? state.initialItems : [];
    List<dynamic> items = packBloc.packs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DropdownButton(
          iconSize: 0,
          isDense: true,
          underline: Container(),
          items: items
              .map((pack) => DropdownMenuItem<Pack>(
                  value: pack,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    child: CachedNetworkImage(
                      imageUrl: pack.image,
                      placeholder: (context, url) => Text(pack.name),
                      fit: BoxFit.contain,
                    ),
                  )))
              .toList(),
          //TODO Багц сунгах таб биш бол яах?
          value: state.selectedTab == PackTabType.ADDITIONAL_CHANNEL ||
                  state.selectedPack == null ||
                  !(state.selectedPack is Pack)
              ? items.first
              : state.selectedPack,
          onChanged: (value) {
            if (state.selectedTab ==
                PackTabType
                    .EXTEND) //TODO сонгосон таб нь [НЭМЭЛТ СУВАГ || АХИУЛАХ] бол яах ёстой ??
              packBloc
                  .dispatch(PackTypeSelectorClicked(state.selectedTab, value));
          },
        ),
        Icon(
          Icons.arrow_drop_down,
          color: Color.fromRGBO(48, 105, 178, 1),
        )
      ],
    );
  }

  @override
  void dispose() {
    packBloc.dispose();
    super.dispose();
  }

  Widget buildContents() {
    var _state = packBloc.currentState;
    if (_state is Loading)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (_state is PackPaymentState) {
      //Багц сунгах төлбөр төлөлтийн үр дүн
      ActionButton chargeAccountBtn =
          ActionButton(title: 'Цэнэглэх', onTap: () {});
      ActionButton closeDialog = ActionButton(title: 'Болих', onTap: () {});

      var paymentResultDialog = CustomDialog(
        title: Text('Анхааруулга',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xfffcfdfe),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 15.0)),
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
      automaticallyImplyLeading: false,
      title: buildAppBarHeader(context, _state),
      bottom: createTabBar,
      backgroundColor: Colors.white,
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
