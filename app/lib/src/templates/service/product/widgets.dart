import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/models/design.dart';
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
        crossAxisCount: _isChannelDetailPicker ? 3 : 2,
        childAspectRatio: _isChannelDetailPicker ? 1.7 : 1.8,
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
        _contentItems.add(_createComponentForPick(month, _productContent, isChannelDetail: true));

      ///Өөр сонголт оруулах button <нэмэлт суваг сонгох талбар биш бол харуулна>
      _contentItems.add(_createComponentForPick(null, _productContent, isChannelDetail: true));
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
      {isChannelPicker = false, isChannelDetail = false}) {
    TextStyle pickerTextStyle = TextStyle(fontSize: 12);

    List<Widget> children = [
      Padding(
        padding: EdgeInsets.all(2),
        child: Text(
          "Өөр сонголт хийх",
          textAlign: TextAlign.center,
          style: pickerTextStyle,
        ),
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
              Text(
                "${item} сар",
                style: pickerTextStyle,
              ),
              Container(
                height: 5,
              ),
              Text(
                "₮ ${PriceFormatter.productPriceFormat(item * selectedPack.price)}",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: pickerTextStyle.fontSize),
              )
            ];

    var pickerPadding = isChannelDetail ? EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6) : EdgeInsets.only(top: 14, bottom: 14, left: 24, right: 24);

    return GestureDetector(
        child: Container(
          padding: pickerPadding,
          child: Container(
            decoration: BoxDecoration(
                color: isChannelPicker
                    ? Colors.white
                    : item == null
                        ? Color.fromRGBO(164, 207, 255, 1)
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
          Constants.appIcons[AppIcons.Back],
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
    var titles = ["Багц", "Хугацаа", "Дүн"];
    List<Widget> contentsForGrid = [];

    var style = TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xff071f49),
        fontSize: 12,
        fontFamily: 'Montserrat');
    var boldStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: style.fontSize,
        fontFamily: 'Montserrat');

    contentsForGrid
        .addAll(titles.map((title) => Text("$title", style: style)).toList());
    SelectedProductPreview state = _bloc.currentState;

    var isUpgradeOrChannel =
        state.selectedProductTab == ProductTabType.ADDITIONAL_CHANNEL ||
            state.selectedProductTab == ProductTabType.UPGRADE;

    contentsForGrid.add(isUpgradeOrChannel
        ? Padding(
            padding: EdgeInsets.only(right: 40),
            child: CachedNetworkImage(
              imageUrl: state.selectedProduct.image,
              placeholder: (context, url) => Text(
                    state.selectedProduct.name,
                    style: style,
                  ),
              fit: BoxFit.contain,
            ))
        : Text(
            state.selectedProduct.name,
            style: boldStyle,
            softWrap: true,
          ));
    contentsForGrid.add(Text("${state.monthToExtend} сар", style: boldStyle));

//      TODO сонгосон сарын сарын төлбөрийг яаж бодох ???
    contentsForGrid.add(Text(
        "₮${PriceFormatter.productPriceFormat(state.selectedProduct.price * state.monthToExtend)}",
        style: boldStyle));

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Text(
                "Сунгах",
                style: boldStyle,
                textAlign: TextAlign.start,
              )),
          FlatButton(
            padding: EdgeInsets.only(bottom: 20, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Constants.appIcons[AppIcons.Back],
                UnderlinedText(
                  "Төлбөрийн мэдээлэл",
                  textStyle: TextStyle(fontSize: 13),
                  underlineWidth: 1,
                ),
                Divider(),
              ],
            ),
            onPressed: () => _bloc.dispatch(
                BackToPrevState(_bloc.currentState.selectedProductTab)),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Scaffold(
              body: GridView.count(
                padding: EdgeInsets.only(left: 40),
                childAspectRatio: 2.5,
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                children: contentsForGrid,
              ),
              floatingActionButton: FlatButton(
                child: UnderlinedText("Үндсэн дансаар"),
                onPressed: () => {},
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          ),
          SubmitButton(
              text: "Сунгах",
              padding: EdgeInsets.only(top: 50),
              onPressed: () => _bloc.dispatch(ExtendSelectedProduct(
                  state.selectedProductTab,
                  state.selectedProduct,
                  state.monthToExtend)),
              verticalMargin: 0,
              horizontalMargin: 0)
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
      style: TextStyle(fontSize: 10),
    );
    Widget backComponent = isUpgradeOrChannel
        ? Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: state.selectedProduct.image,
                  placeholder: (context, url) =>
                      Text(state.selectedProduct.name),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(width: MediaQuery.of(context).size.width, child: label)
          ])
        : label;
    return ListView(
      children: [
        Column(
          children: <Widget>[
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Constants.appIcons[AppIcons.Back],
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: backComponent,
                  ),
                  Divider()
                ],
              ),
              //TODO back to previous page
              onPressed: () => widget._bloc.dispatch(BackToPrevState(
                  widget._bloc.currentState.selectedProductTab)),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.055,
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                style: TextStyle(fontFamily: "Segoe UI"),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
                onChanged: (value) => setState(() {
                      customMonthValue = value;
                      paymentPreview =
                          "${(value.isEmpty ? 0 : int.parse(value)) * state.selectedProduct.price}";
                    }),
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Text(
              "Сунгах сарын үнийн дүн",
              style: TextStyle(fontSize: 10),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                  "₮${PriceFormatter.productPriceFormat(paymentPreview)}",
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

class UnderlinedText extends StatelessWidget {
  String title;
  TextStyle textStyle;
  Color underlineColor;
  double underlineWidth;

  UnderlinedText(this.title,
      {this.textStyle = const TextStyle(fontSize: 13),
      this.underlineWidth = 2,
      this.underlineColor = const Color.fromRGBO(48, 105, 178, 1)});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "$title",
        style: textStyle,
      ),
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: underlineColor, width: underlineWidth))),
    );
  }
}
