import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/models/product.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/utils/price_format.dart';
import 'package:ddish/src/widgets/ui_mixins.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class ProductGridPicker extends StatelessWidget with WidgetMixin {
  ProductBloc _bloc;
  var _state;
  var _stateTab;
  BuildContext _context;
  dynamic _productContent; //products or product

  ProductGridPicker(this._bloc, this._productContent) : assert(_bloc != null) {
    _state = _bloc.currentState;
    _stateTab = _state.selectedProductTab;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    assert(_productContent != null);

    return buildContentContainer(context);
  }

  Widget buildContentContainer(context) {
    //аль табаас хамаарч түүний GridView д харуулах content уудыг бэлдэх
    var contentsForGrid = _buildContents();

    if (_stateTab == ProductTabType.UPGRADE) {
      return GridView.extent(
        maxCrossAxisExtent: 200,
        children: contentsForGrid,
        childAspectRatio: 0.23,
        scrollDirection: Axis.vertical,
      );
    } else {
      var _isChannelDetailPicker =
          _stateTab == ProductTabType.ADDITIONAL_CHANNEL &&
              _productContent is Product;

      var pickerContainer = GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        children: contentsForGrid,
      );

      if (_isChannelDetailPicker) {
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              title: _buildChannelDetailPickerHeader(_productContent),
            ),
            body: pickerContainer);
      }

      return pickerContainer;
    }
  }

  List<Widget> _buildContents() {
    if (_stateTab == ProductTabType.ADDITIONAL_CHANNEL)
      return _buildChannelContents();
    else if (_stateTab == ProductTabType.UPGRADE)
      return _buildPackUpgradeContents();

    //багц сунгах бол
    List<Widget> _contentItems = Constants.extendableMonths
        .map((month) => _createComponentForPick(month, _productContent))
        .toList();

    _contentItems.add(_createComponentForPick(null, _productContent));
    return _contentItems;
  }

  List<Widget> _buildChannelContents() {
    bool _isChannelDetail =
        _productContent is Product; //list биш бол channel detail

    List<Widget> _contentItems = [];

    if (_isChannelDetail) {
      for (final month in Constants
          .extendableMonths) //TODO List<Widget> рүү яагаад map хийж болохгүй байгааг шалгах
        _contentItems.add(_createComponentForPick(month, _productContent));

      ///Өөр сонголт оруулах button <нэмэлт суваг сонгох талбар биш бол харуулна>
      _contentItems.add(_createComponentForPick(null, _productContent));
    } else
      for (final product
          in _productContent) //TODO List<Widget> рүү яагаад map хийж болохгүй байгааг шалгах
        _contentItems.add(
            _createComponentForPick(product, product, isChannelPicker: true));
    return _contentItems;
  }

  List<Widget> _buildPackUpgradeContents() {
    List<Widget> _contentItems = [];
    for (final Product product in _productContent) {
      List<Widget> children = [];
//    багцын лого бүхий component ыг эхлээд нэмэх, түүний араас тухайн багцад хамаар үнэ&хугацааны багцуудыг нэмэх
      children.add(Flexible(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CachedNetworkImage(
            imageUrl: product.image,
            placeholder: (context, url) => Text(product.name),
            fit: BoxFit.contain,
          ),
        ),
      )); //channelPackImage

      List<Widget> itemsOfChannel = Constants.extendableMonths
          .map((month) => _createComponentForPick(month, product))
          .toList();

      children.addAll(itemsOfChannel);

      children.add(_createComponentForPick(null, product));

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
          : [
              Text("${item} сар"),
              Container(
                height: 10,
              ),
              Text(
                "₮ ${PriceFormatter.productPriceFormat(item * selectedPack.price)}",
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ];

    return GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
                color: isChannelPicker
                    ? Colors.white
                    : Color.fromRGBO(134, 187, 255, 1),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
        onTap: () {
          var selected = selectedPack != null ? selectedPack : _productContent;
          if (item == null) //өөр сонголт хийх бол
            _bloc.dispatch(
                CustomProductSelected(_state.selectedProductTab, selected, 0));
          else if (isChannelPicker)
            _bloc.dispatch(
                ProductItemSelected(_state.selectedProductTab, item, null));
          else {
            var event =
                ProductItemSelected(_state.selectedProductTab, selected, item);
            openPermissionDialog(_bloc, _context, event, item);
          }
        });
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
      onPressed: () => _bloc
          .dispatch(BackToPrevState(_bloc.currentState.selectedProductTab)),
    );
  }
}

class ProductPaymentPreview extends StatelessWidget {
  final ProductBloc _bloc;
  ProductPaymentPreview(this._bloc);

  @override
  Widget build(BuildContext context) {
    var titles = ["Багц", "Хугацаа", "Үнэ"];
    List<Widget> contentsForGrid = [];

    contentsForGrid.addAll(titles.map((title) => Text("$title")).toList());
    SelectedProductPreview state = _bloc.currentState;

    var style =
        TextStyle(fontWeight: FontWeight.bold, color: Color(0xff071f49));

    var isUpgradeOrChannel =
        state.selectedProductTab == ProductTabType.ADDITIONAL_CHANNEL ||
            state.selectedProductTab == ProductTabType.UPGRADE;

    contentsForGrid.add(isUpgradeOrChannel
        ? Padding(
            padding: EdgeInsets.only(right: 40, bottom: 15),
            child: CachedNetworkImage(
              imageUrl: state.selectedProduct.image,
              placeholder: (context, url) => Text(state.selectedProduct.name),
              fit: BoxFit.contain,
            ))
        : Text(state.selectedProduct.name, style: style));
    contentsForGrid.add(Text("${state.monthToExtend} сар", style: style));

//      TODO сонгосон сарын сарын төлбөрийг яаж бодох ???
    contentsForGrid.add(Text(
        "₮${state.selectedProduct.price * state.monthToExtend}",
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
            onPressed: () => _bloc.dispatch(
                BackToPrevState(_bloc.currentState.selectedProductTab)),
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
                    onPressed: () => _bloc.dispatch(ExtendSelectedProduct(
                        state.selectedProductTab,
                        state.selectedProduct,
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

class CustomProductChooser extends StatefulWidget {
  ProductBloc _bloc;

  CustomProductChooser(this._bloc);

  @override
  State<StatefulWidget> createState() => CustomProductChooserState();
}

class CustomProductChooserState extends State<CustomProductChooser>
    with WidgetMixin {
  String paymentPreview = "0";
  String customMonthValue = "0";

  @override
  Widget build(BuildContext context) {
    var state = widget._bloc.currentState;
    var isUpgradeOrChannel =
        state.selectedProductTab == ProductTabType.ADDITIONAL_CHANNEL ||
            state.selectedProductTab == ProductTabType.UPGRADE;

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
                  imageUrl: state.selectedProduct.image,
                  placeholder: (context, url) =>
                      Text(state.selectedProduct.name),
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
              onPressed: () => widget._bloc.dispatch(BackToPrevState(
                  widget._bloc.currentState.selectedProductTab)),
            ),
            Card(
              margin: EdgeInsets.all(40),
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) => setState(() {
                      customMonthValue = value;
                      paymentPreview =
                          "${(value.isEmpty ? 0 : int.parse(value)) * state.selectedProduct.price}";
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
    var event = PreviewSelectedProduct(
        state.selectedProductTab, state.selectedProduct, time);

    //TODO сарыг өөр дүнгээр оруулсан үед үнийг тооцох
    openPermissionDialog(widget._bloc, context, event, time);
  }
}
