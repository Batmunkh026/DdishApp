import 'package:ddish/src/blocs/service/pack/pack_bloc.dart';
import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/models/month_price.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class PackGridPicker extends StatelessWidget {
  PackBloc _bloc;
  var _state;

  Pack _pack;

  PackGridPicker(this._bloc, this._pack) : assert(_bloc != null) {
    _state = _bloc.currentState;
  }

  @override
  Widget build(BuildContext context) {
    assert(_pack != null);

    var contents = _pack.packsForMonth.map((mp) {
      return createComponentForPick(mp);
    }).toList();

    ///Өөр сонголт оруулах button
    contents.add(createComponentForPick(null));

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / (itemHeight / 4)),
      children: contents,
    );
  }

  Widget createComponentForPick(MonthAndPriceToExtend mp) {
    List<Widget> children = [Text("Өөр сонголт оруулах")];

    if (mp != null)
      children = [Text("${mp.monthToExtend} сар"), Text("₮${mp.price}")];

    return Card(
      elevation: 0,
      child: GestureDetector(
          child: Card(
            color: Color.fromRGBO(49, 138, 255, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
          onTap: () => _bloc.dispatch(mp == null
              ? CustomPackSelected(_state.selectedTab, _pack, 0)
              : PackItemSelected(_state.selectedTab, _pack, mp))),
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
    var selectedPack = state.selectedPack as Pack;

    var style =
        TextStyle(fontWeight: FontWeight.bold, color: Color(0xff071f49));

    contentsForGrid.add(Text(selectedPack.name, style: style));
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.arrow_back_ios),
                Text("Төлбөрийн мэдээлэл")
              ],
            ),
            onPressed: () => {},
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
                        state.selectedTab, selectedPack, state.monthToExtend)),
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
                  .mapEventToState(PackServiceSelected(PackTabType.EXTEND)),
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
