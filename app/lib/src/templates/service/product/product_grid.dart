import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/models/design.dart';
import 'package:ddish/src/models/product.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/utils/price_format.dart';
import 'package:ddish/src/widgets/ui_mixins.dart';
import 'package:flutter/material.dart';

class ProductGridPicker extends StatelessWidget with WidgetMixin {
  ProductBloc _bloc;
  var _state;
  var _stateTab;
  BuildContext _context;
  dynamic _productContent; //products or product

  double pickerWidth;
  double pickerHeight;

  ProductGridPicker(this._bloc, this._productContent) : assert(_bloc != null) {
    _state = _bloc.currentState;
    _stateTab = _state.selectedProductTab;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    pickerWidth = MediaQuery.of(_context).size.width * 0.25;
    pickerHeight = pickerWidth * 0.63;

    assert(_productContent != null);

    return buildContentContainer(context);
  }

  Widget buildContentContainer(context) {
    //аль табаас хамаарч түүний GridView д харуулах content уудыг бэлдэх
    var contentsForGrid = _buildContents();

    double width = MediaQuery.of(context).size.width;
    double ratio = MediaQuery.of(context).devicePixelRatio;
    EdgeInsets insets = MediaQuery.of(context).viewInsets;
    if (_stateTab == ProductTabType.UPGRADE) {
      return GridView.count(
        padding: EdgeInsets.only(top: 10),
        children: contentsForGrid,
        childAspectRatio: 0.4,
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
      );
    } else {
      var _isChannelDetailPicker =
          _stateTab == ProductTabType.ADDITIONAL_CHANNEL &&
              _productContent is Product;

      var pickerContainer = GridView.count(
        padding: EdgeInsets.only(top: 20),
        scrollDirection: Axis.vertical,
        crossAxisCount: _isChannelDetailPicker ? 3 : 2,
        childAspectRatio: _isChannelDetailPicker ? 1.6 : 2,
        children: contentsForGrid,
      );

      if (_isChannelDetailPicker) {
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
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
        .map((month) => _createComponentForPick(_productContent, month: month))
        .toList();

    _contentItems.add(_createComponentForPick(_productContent, isMore: true));
    return _contentItems;
  }

  List<Widget> _buildChannelContents() {
    bool _isChannelDetail =
        _productContent is Product; //list биш бол channel detail

    List<Widget> _contentItems = [];

    if (_isChannelDetail) {
      for (final month in Constants
          .extendableMonths) //TODO List<Widget> рүү яагаад map хийж болохгүй байгааг шалгах
        _contentItems.add(_createComponentForPick(_productContent,
            month: month, isChannelDetail: true));

      ///Өөр сонголт оруулах button <нэмэлт суваг сонгох талбар биш бол харуулна>
      _contentItems.add(_createComponentForPick(_productContent,
          isChannelDetail: true, isMore: true));
    } else
      for (final product
          in _productContent) //TODO List<Widget> рүү яагаад map хийж болохгүй байгааг шалгах
        _contentItems
            .add(_createComponentForPick(product, isChannelPicker: true));
    return _contentItems;
  }

  List<Widget> _buildPackUpgradeContents() {
    List<Widget> _contentItems = [];
    for (final UpProduct product in _productContent) {
      List<Widget> children = [];
//    багцын лого бүхий component ыг эхлээд нэмэх, түүний араас тухайн багцад хамаар үнэ&хугацааны багцуудыг нэмэх
      children.add(Flexible(
        child: Container(
          width: pickerWidth,
          height: pickerHeight,
          child: CachedNetworkImage(
            imageUrl: product.image,
            placeholder: (context, url) => Text(product.name),
            fit: BoxFit.contain,
          ),
        ),
      ));

      List<Widget> itemsOfProduct = product.prices
          .map((upProductPrice) => Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: _createComponentForPick(product,
                    month: upProductPrice.month, price: upProductPrice.price),
              ))
          .toList();

      children.addAll(itemsOfProduct);

      children.add(_createComponentForPick(product, isMore: true));

      Column packContainer = Column(children: children);
      _contentItems.add(packContainer);
    }

    return _contentItems;
  }

  ///item -> month
  ///selectedProduct -> Product or UpProduct
  Widget _createComponentForPick(Product selectedProduct,
      {price = 0,
      month = null,
      isChannelPicker = false,
      isChannelDetail = false,
      isMore = false}) {
    if (price == 0) price = selectedProduct.price;
    TextStyle pickerTextStyle = TextStyle(fontSize: 12);

    List<Widget> children = [
      Text(
        "Өөр сонголт хийх",
        textAlign: TextAlign.center,
        style: pickerTextStyle,
      ),
    ];

    if (!isMore)
      children = isChannelPicker
          ? [
              Flexible(
                  child: CachedNetworkImage(
                //TODO default local image resource нэмэх
                imageUrl: selectedProduct.image,
                placeholder: (context, text) => Text(selectedProduct.name),
              ))
            ]
          : [
              Text(
                "${month} сар",
                style: pickerTextStyle,
              ),
              Container(
                height: 5,
              ),
              Text(
                "₮ ${PriceFormatter.productPriceFormat(month * (price))}",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: pickerTextStyle.fontSize),
              )
            ];

//    var pickerPadding = isChannelDetail
//        ? EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6)
//        : EdgeInsets.only(top: 14, bottom: 14, left: 24, right: 24);

    return GestureDetector(
        child: Center(
//          padding: pickerPadding,
          child: Container(
            width: pickerWidth,
            height: pickerHeight,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: isChannelPicker
                    ? Colors.white
                    : isMore
                        ? Color.fromRGBO(164, 207, 255, 1)
                        : Color.fromRGBO(134, 187, 255, 1),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
        onTap: () {
          if (isChannelPicker)
            _bloc.dispatch(ProductItemSelected(
                _state.selectedProductTab, selectedProduct, month, price));
          else if (isMore) //өөр сонголт хийх бол
            _bloc.dispatch(CustomProductSelected(
                _state.selectedProductTab, selectedProduct, 0, price));
          else {
            var event = ProductItemSelected(
                _state.selectedProductTab, selectedProduct, month, price);

            openPermissionDialog(
                _bloc, _context, event, selectedProduct.name, month, price);
          }
        });
  }

  Widget _buildChannelDetailPickerHeader(selectedChannel) {
    return FlatButton(
      padding: EdgeInsets.only(top: 20),
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