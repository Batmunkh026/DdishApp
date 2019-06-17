import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/pack/pack_bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/ui_mixins.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class PackGridPicker extends StatelessWidget with WidgetMixin {
  PackBloc _bloc;
  var _state;
  var _stateTab;
  BuildContext _context;
  dynamic _pack;

  PackGridPicker(this._bloc, this._pack) : assert(_bloc != null) {
    _state = _bloc.currentState;
    _stateTab = _state.selectedTab;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    assert(_pack != null);

//    TODO fix logic error [ хэрэв зөвхөн сувгуудын цуглуулга байвал isChannelPicker==TRUE болно, үгүй бол багц сунгахтай адил үйлдэл хийх]

    return buildContentContainer(context);
  }

  Widget buildContentContainer(context) {
    //аль табаас хамаарч түүний GridView д харуулах content уудыг бэлдэх
    var contentsForGrid = _buildContents();

    if (_stateTab == PackTabType.UPGRADE) {
      return GridView.extent(
        maxCrossAxisExtent: 200,
        children: contentsForGrid,
        childAspectRatio: 0.33,
        scrollDirection: Axis.vertical,
      );
    } else {
//      var size = MediaQuery.of(context).size;
//
//      final double _itemHeight = (size.height - kToolbarHeight - 24) / 2;
//      final double _itemWidth = size.width / 2;

      //    is channel detail picker бол
      var _isChannelDetailPicker =
          _stateTab == PackTabType.ADDITIONAL_CHANNEL && _pack is Channel;

      var pickerContainer = GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        children: contentsForGrid,
      );

      if (_isChannelDetailPicker) {
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              title: _buildChannelDetailPickerHeader(_pack),
            ),
            body: pickerContainer);
      }

      return pickerContainer;
    }
  }

  List<Widget> _buildContents() {
    if (_stateTab == PackTabType.ADDITIONAL_CHANNEL)
      return _buildChannelContents();
    else if (_stateTab == PackTabType.UPGRADE)
      return _buildPackUpgradeContents();

    //багц сунгах бол
    List<Widget> _contentItems = Constants.extendableMonths
        .map((month) => _createComponentForPick(month, _pack))
        .toList();

    _contentItems.add(_createComponentForPick(null, _pack));
    return _contentItems;
  }

  List<Widget> _buildChannelContents() {
    bool _isChannelDetail = _pack is Channel; //list биш бол channel detail

    List<Widget> _contentItems = [];

    if (_isChannelDetail) {
      for (final month in Constants
          .extendableMonths) //TODO List<Widget> рүү яагаад map хийж болохгүй байгааг шалгах
        _contentItems.add(_createComponentForPick(month, _pack));

      ///Өөр сонголт оруулах button <нэмэлт суваг сонгох талбар биш бол харуулна>
      _contentItems.add(_createComponentForPick(null, _pack));
    } else
      for (final channel
          in _pack) //TODO List<Widget> рүү яагаад map хийж болохгүй байгааг шалгах
        _contentItems.add(
            _createComponentForPick(channel, channel, isChannelPicker: true));
    return _contentItems;
  }

  List<Widget> _buildPackUpgradeContents() {
    List<Widget> _contentItems = [];
    for (final Pack pack in _pack) {
      List<Widget> children = [];
//    багцын лого бүхий component ыг эхлээд нэмэх, түүний араас тухайн багцад хамаар үнэ&хугацааны багцуудыг нэмэх
      children.add(Flexible(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CachedNetworkImage(
            imageUrl: pack.image,
            placeholder: (context, url) => Text(pack.name),
            fit: BoxFit.contain,
          ),
        ),
      )); //channelPackImage

      List<Widget> itemsOfChannel = Constants.extendableMonths
          .map((month) => Expanded(child: _createComponentForPick(month, pack)))
          .toList();

      children.addAll(itemsOfChannel);

      children.add(Expanded(child: _createComponentForPick(null, pack)));

      Column packContainer = Column(children: children);
      _contentItems.add(packContainer);
    }

    return _contentItems;
  }

  Widget _createComponentForPick(dynamic item, dynamic selectedPack,
      {isChannelPicker = false}) {
    List<Widget> children = [
      Text(
        "Өөр сонголт хийх",
        textAlign: TextAlign.center,
      )
    ];

    if (item != null)
      children = isChannelPicker
          ? [
              Flexible(
                  child: CachedNetworkImage(
                //TODO default local image resource нэмэх
                imageUrl: selectedPack.image,
                placeholder: (context, text) => Text(selectedPack.name),
              ))
            ]
          : [Text("${item} сар"), Text("₮${item * selectedPack.price}")];

    return Card(
      elevation: 0,
      child: GestureDetector(
          child: Card(
            elevation: 0,
            color: isChannelPicker
                ? Colors.white
                : Color.fromRGBO(49, 138, 255, 1),
            child: Padding(
              padding: EdgeInsets.only(right: 40, left: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          ),
          onTap: () {
            var selected = selectedPack != null ? selectedPack : _pack;
            if (item == null) //өөр сонголт хийх бол
              _bloc.dispatch(
                  CustomPackSelected(_state.selectedTab, selected, 0));
            else if (isChannelPicker)
              _bloc.dispatch(PackItemSelected(_state.selectedTab, item, null));
            else {
              var event = PackItemSelected(_state.selectedTab, selected, item);
              openPermissionDialog(_bloc, _context, event, item);
            }
          }),
    );
  }

  Widget _buildChannelDetailPickerHeader(selectedChannel) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.arrow_back_ios),
          CachedNetworkImage(
            imageUrl: selectedChannel.image,
            placeholder: (context, text) => Text(selectedChannel.name),
          ),
          Divider()
        ],
      ),
      //TODO back to previous page
      onPressed: () =>
          _bloc.dispatch(BackToPrevState(_bloc.currentState.selectedTab)),
    );
  }
}

class PackPaymentPreview extends StatelessWidget {
  final PackBloc _bloc;
  PackPaymentPreview(this._bloc);

  @override
  Widget build(BuildContext context) {
    var titles = ["Багц", "Хугацаа", "Үнэ"];
    List<Widget> contentsForGrid = [];

    contentsForGrid.addAll(titles.map((title) => Text("$title")).toList());
    SelectedPackPreview state = _bloc.currentState;

    var style =
        TextStyle(fontWeight: FontWeight.bold, color: Color(0xff071f49));

    var isUpgradeOrChannel =
        state.selectedTab == PackTabType.ADDITIONAL_CHANNEL ||
            state.selectedTab == PackTabType.UPGRADE;

    contentsForGrid.add(isUpgradeOrChannel
        ? Padding(
            padding: EdgeInsets.only(right: 40, bottom: 15),
            child: CachedNetworkImage(
              imageUrl: state.selectedPack.image,
              placeholder: (context, url) => Text(state.selectedPack.name),
              fit: BoxFit.contain,
            ))
        : Text(state.selectedPack.name, style: style));
    contentsForGrid.add(Text("${state.monthToExtend} сар", style: style));

//      TODO сонгосон сарын сарын төлбөрийг яаж бодох ???
    contentsForGrid.add(Text(
        "₮${state.selectedPack.price * state.monthToExtend}",
        style: style));

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Буцах",
                style: style,
                textAlign: TextAlign.start,
              )),
          FlatButton(
            padding: EdgeInsets.only(bottom: 20, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.arrow_back_ios),
                Text("Төлбөрийн мэдээлэл"),
                Divider(),
              ],
            ),
            onPressed: () =>
                _bloc.dispatch(BackToPrevState(_bloc.currentState.selectedTab)),
          ),
          Expanded(
            child: Scaffold(
              body: GridView.count(
                padding: EdgeInsets.only(left: 30),
                childAspectRatio: 3,
                crossAxisCount: 3,
                children: contentsForGrid,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Үндсэн дансаар",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
                SubmitButton(
                    text: "Сунгах",
                    onPressed: () => _bloc.dispatch(ExtendSelectedPack(
                        state.selectedTab,
                        state.selectedPack,
                        state.monthToExtend)),
                    verticalMargin: 0,
                    horizontalMargin: 0)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomPackChooser extends StatefulWidget {
  PackBloc _bloc;

  CustomPackChooser(this._bloc);

  @override
  State<StatefulWidget> createState() => CustomPackChooserState();
}

class CustomPackChooserState extends State<CustomPackChooser> with WidgetMixin {
  String paymentPreview = "0";
  String customMonthValue = "0";

  @override
  Widget build(BuildContext context) {
    var state = widget._bloc.currentState;
    var isUpgradeOrChannel =
        state.selectedTab == PackTabType.ADDITIONAL_CHANNEL ||
            state.selectedTab == PackTabType.UPGRADE;

    var label = Text(
      "Сунгах сарын тоогоо оруулна уу",
      style: TextStyle(fontSize: 12),
    );
    Widget backComponent = isUpgradeOrChannel
        ? Column(children: <Widget>[
            Container(
              height: 60,
              child: Padding(
                padding: EdgeInsets.only(right: 40, left: 40, top: 20),
                child: CachedNetworkImage(
                  imageUrl: state.selectedPack.image,
                  placeholder: (context, url) => Text(state.selectedPack.name),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            label
          ])
        : label;
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Column(
          children: <Widget>[
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.arrow_back_ios),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: backComponent,
                  )
                ],
              ),
              //TODO back to previous page
              onPressed: () => widget._bloc.dispatch(
                  BackToPrevState(widget._bloc.currentState.selectedTab)),
            ),
            Card(
              margin: EdgeInsets.all(40),
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) => setState(() {
                      customMonthValue = value;
                      paymentPreview =
                          "${(value.isEmpty ? 0 : int.parse(value)) * state.selectedPack.price}";
                    }),
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Text("Сунгах сарын үнийн дүн"),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text("₮${paymentPreview}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SubmitButton(
                text: "Сунгах",
                onPressed: () => toExtend(state),
                verticalMargin: 0,
                horizontalMargin: 0)
          ],
        )
      ],
    );
  }

  int _toInt(String text) {
    return text.isEmpty ? 0 : int.parse(text);
  }

  toExtend(state) {
    var time = _toInt(customMonthValue);
    var event =
        PreviewSelectedPack(state.selectedTab, state.selectedPack, time);

    //TODO сарыг өөр дүнгээр оруулсан үед үнийг тооцох
    openPermissionDialog(widget._bloc, context, event, time);
  }
}
