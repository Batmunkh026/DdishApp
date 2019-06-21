import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/models/product.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/templates/service/product/widgets.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  ProductBloc bloc;

  var productTabs = Constants.productTabs;

  get createTabBar => TabBar(
        isScrollable: true,
        tabs: productTabs
            .map((tabItem) => Tab(
                child: Text(tabItem.title,
                    style: TextStyle(color: Color(0xff071f49), fontSize: 11, fontWeight: FontWeight.w600))))
            .toList(),
        onTap: (tabIndex) =>
            bloc.dispatch(ProductTabChanged(productTabs[tabIndex].state)),
        indicatorColor: Color.fromRGBO(48, 105, 178, 1),
      );
  @override
  void initState() {
    bloc = ProductBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, ProductState state) {
          return DefaultTabController(
              length: productTabs.length, child: buildBody());
        });
  }

  Widget buildAppBarHeader(BuildContext context, ProductState state) {
    var fontStyle = TextStyle(color: const Color(0xff071f49), fontSize: 11.0);

    var productContentContainer = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("Идэвхтэй багц", style: fontStyle),
                    new Text("Дуусах хугацаа: ", style: fontStyle),
                  ],
                ),
              ),
              new Text(
                  "${DateUtil.formatProductDate(bloc.getDateOfUserSelectedProduct())}",
                  style: TextStyle(
                      color: const Color(0xff071f49),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0)),
            ],
          ),
        ),
      ],
    );
    if (state is SelectedProductPreview)
      return Text("Сунгах");
    else if (state is ProductTabState ||
        state is CustomProductSelector ||
        state is ProductSelectionState)
      productContentContainer.children.add(createProductPicker(state));

    return Container(
      padding: EdgeInsets.all(10),
      child: productContentContainer,
    );
  }

  Widget createProductPicker(ProductState state) {
    List<Product> items = bloc.products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DropdownButton(
          iconSize: 0,
          isDense: true,
          underline: Container(),
          items: items
              .map((product) => DropdownMenuItem<Product>(
                  value: product,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      placeholder: (context, url) => Text(product.name),
                      fit: BoxFit.contain,
                    ),
                  )))
              .toList(),
          //TODO Багц сунгах таб биш бол яах?
          value:
              bloc.selectedProduct == null ? items.first : bloc.selectedProduct,
          onChanged: (value) {
            if (state.selectedProductTab ==
                ProductTabType
                    .EXTEND) //TODO сонгосон таб нь [НЭМЭЛТ СУВАГ || АХИУЛАХ] бол яах ёстой ??
              bloc.dispatch(
                  ProductTypeSelectorClicked(state.selectedProductTab, value));
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
    bloc.dispose();
    super.dispose();
  }

  Widget buildContents() {
    var _state = bloc.currentState;

    if (_state is ProductPaymentState) {
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
    } else if (_state is ProductTabState || _state is ProductSelectionState) {
      //багц сунгах бол сонгосон багцыг , бусад таб бол боломжит бүх багцуудыг
      var itemsForGrid = _state.selectedProductTab == ProductTabType.EXTEND
          ? _state.selectedProduct
          : _state.initialItems;
      var productPicker = ProductGridPicker(bloc, itemsForGrid);
      return productPicker;
    } else if (_state is AdditionalChannelState) {
      //нэмэлт суваг сонгосон төлөв
      return ProductGridPicker(bloc, _state.selectedProduct);
    } else if (_state is SelectedProductPreview) {
      return ProductPaymentPreview(bloc);
    } else if (_state is CustomProductSelector) {
      return CustomProductChooser(bloc);
    } else
      throw UnsupportedError("Тодорхойгүй state: $_state");
  }

  AppBar buildAppBar() {
    var _state = bloc.currentState;
    if (_state is SelectedProductPreview)
      return AppBar(
        backgroundColor: Colors.white,
        title: buildAppBarHeader(context, _state),
      );

    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: buildAppBarHeader(context, _state),
      centerTitle: true,
      titleSpacing: 10,
      title: Container(padding: EdgeInsets.only(top: 25), height: 90, child: createTabBar,),
      backgroundColor: Colors.white,
    );
  }

  Widget buildBody() {
    if (bloc.currentState is Loading)
      return Center(child: CircularProgressIndicator());

    if (bloc.currentState is SelectedProductPreview) return buildContents();

    return Scaffold(
      appBar: buildAppBar(),
      body: buildContents(),
    );
  }
}
