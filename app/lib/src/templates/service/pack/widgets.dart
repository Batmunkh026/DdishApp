import 'package:ddish/src/blocs/service/pack/pack_bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/month_price.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class PackGridPicker extends StatelessWidget {
  PackBloc _bloc;
  var _state;

  dynamic _pack;

  PackGridPicker(this._bloc, this._pack) : assert(_bloc != null) {
    _state = _bloc.currentState;
  }

  @override
  Widget build(BuildContext context) {
    assert(_pack != null);
    var _stateTab = _state.selectedTab;
//    TODO fix logic error [ хэрэв зөвхөн сувгуудын цуглуулга байвал isChannelPicker==TRUE болно, үгүй бол багц сунгахтай адил үйлдэл хийх]
    var isChannelPicker =
        _stateTab == PackTabType.ADDITIONAL_CHANNEL && !(_pack is Channel);

    List<dynamic> items = isChannelPicker ? _pack : _pack.packsForMonth;

    List<Widget> contents = items
        .map((item) => createComponentForPick(item, isChannelPicker))
        .toList();

    ///Өөр сонголт оруулах button <нэмэлт суваг сонгох талбар биш бол харуулна>
    if (!isChannelPicker)
      contents.add(createComponentForPick(null, isChannelPicker));

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    //    is channel detail picker бол
    var isChannelDetailPicker =
        _stateTab == PackTabType.ADDITIONAL_CHANNEL && _pack is Channel;

    var pickerContainer = GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / (itemHeight / 4)),
      children: contents,
    );

    if (isChannelDetailPicker) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: buildChannelDetailPickerHeader(_pack),
          ),
          body: pickerContainer);
    }

    return pickerContainer;
  }

  Widget createComponentForPick(dynamic item, isChannelPicker) {
    List<Widget> children = [Text("Өөр сонголт оруулах")];

    if (item != null)
      children = isChannelPicker
          ? [Flexible(child: Image.network(item.image))]
          : [Text("${item.monthToExtend} сар"), Text("₮${item.price}")];

    return Card(
      elevation: 0,
      child: GestureDetector(
          child: Card(
            elevation: 0,
            color: isChannelPicker
                ? Colors.white
                : Color.fromRGBO(49, 138, 255, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
          onTap: () {
            if (item == null)
              _bloc.dispatch(CustomPackSelected(_state.selectedTab, _pack, 0));

            if (isChannelPicker)
              _bloc.dispatch(PackItemSelected(_state.selectedTab, item, null));
            else
              _bloc.dispatch(PackItemSelected(_state.selectedTab, _pack, item));
          }),
    );
  }

  Widget buildChannelDetailPickerHeader(selectedChannel) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.arrow_back_ios),
          Image.network(selectedChannel.image),
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

    contentsForGrid.add(state.selectedTab == PackTabType.ADDITIONAL_CHANNEL
        ? Image.network(state.selectedPack.image)
        : Text(state.selectedPack.name, style: style));
    contentsForGrid.add(Text("${state.monthToExtend} сар", style: style));

//      TODO сонгосон сарын сарын төлбөрийг яаж бодох ???
    contentsForGrid.add(Text("₮0", style: style));

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

class CustomPackChooser extends StatelessWidget {
  PackBloc _bloc;

  CustomPackChooser(this._bloc);

  get _monthValueController => TextEditingController();

  @override
  Widget build(BuildContext context) {
    String input;
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
                  Text("Сунгах сарын тоогоо оруулна уу")
                ],
              ),
              //TODO back to previous page
              onPressed: () => _bloc
                  .dispatch(BackToPrevState(_bloc.currentState.selectedTab)),
            ),
            Card(
              margin: EdgeInsets.all(40),
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                controller: _monthValueController,
                onChanged: (value) {
                  input = value;
                },
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Text("Сунгах сарын үнийн дүн"),
            Padding(
              padding: EdgeInsets.all(30),

              ///TODO яаж тооцох???
              child: Text("₮59'600",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SubmitButton(
                text: "Сунгах",
                onPressed: () => _bloc.dispatch(PreviewSelectedPack(
                    _bloc.currentState.selectedTab,
                    _bloc.currentState.selectedPack,
                    toInt(input))),
                verticalMargin: 0,
                horizontalMargin: 0)
          ],
        )
      ],
    );
  }

  int toInt(String text) {
    return text.isEmpty ? 0 : int.parse(text);
  }
}
