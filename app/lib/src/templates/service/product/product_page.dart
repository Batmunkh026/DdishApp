import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/blocs/service/service_bloc.dart';
import 'package:ddish/src/models/product.dart';
import 'package:ddish/src/models/tab_menu.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/templates/service/product/custom_option_page.dart';
import 'package:ddish/src/templates/service/product/payment_result_page.dart';
import 'package:ddish/src/templates/service/product/product_grid.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  ProductBloc _bloc;

  var _productTabs = Constants.productTabs;

  TabController _tabController;

  get createTabBar => TabBar(
        isScrollable: true,
        controller: _tabController,
        tabs: _productTabs.map((tabItem) => Tab(text: tabItem.title)).toList(),
        onTap: (tabIndex) =>
            _bloc.dispatch(ProductTabChanged(_productTabs[tabIndex].state)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        labelColor: const Color(0xff071f49),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        indicatorColor: Color(0xFF3069b2),
      );
  @override
  void initState() {
    _bloc = ProductBloc();
    _tabController = TabController(length: _productTabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _serviceBloc = BlocProvider.of<ServiceBloc>(context);

    return BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, ProductState state) {
          return BlocProviderTree(blocProviders: [
            BlocProvider<ServiceBloc>(
              bloc: _serviceBloc,
            ),
            BlocProvider<ProductBloc>(
              bloc: _bloc,
            ),
          ], child: _buildBody());
        });
  }

  Widget _buildAppBarHeader(BuildContext context, ProductState state) {
    var fontStyle =
        TextStyle(color: const Color(0xff071f49), fontWeight: FontWeight.w500);

    var productContentContainer = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
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
                  "${DateUtil.formatProductDate(_bloc.getExpireDateOfUserSelectedProduct())}",
                  style: TextStyle(
                    color: const Color(0xff071f49),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  )),
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
      productContentContainer.children.add(_createProductPicker(state));

    return Container(
      padding: EdgeInsets.all(8),
      child: productContentContainer,
    );
  }

  Widget _createProductPicker(ProductState state) {
    List<Product> items = _bloc.products;

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
          value: _bloc.selectedProduct == null
              ? items.first
              : _bloc.selectedProduct,
          onChanged: (value) {
            if (state.selectedProductTab ==
                ProductTabType
                    .EXTEND) //TODO сонгосон таб нь [НЭМЭЛТ СУВАГ || АХИУЛАХ] бол яах ёстой ??
              _bloc.dispatch(
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
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildContents() {
    var _state = _bloc.currentState;

    if (_state is ProductTabState || _state is ProductSelectionState) {
      //багц сунгах бол сонгосон багцыг , бусад таб бол боломжит бүх багцуудыг
      var itemsForGrid = _state.selectedProductTab == ProductTabType.EXTEND
          ? _state.selectedProduct
          : _state.initialItems;
      var productPicker = ProductGridPicker(itemsForGrid);
      return productPicker;
    } else if (_state is AdditionalChannelState) {
      //нэмэлт суваг сонгосон төлөв
      return ProductGridPicker(_state.selectedProduct);
    } else if (_state is SelectedProductPreview ||
        _state is ProductPaymentState) {
      return ProductPaymentPreview();
    } else if (_state is CustomProductSelector)
      return CustomProductChooser(_state.priceToExtend, 0);
    else if (_state is CustomMonthState)
      return CustomProductChooser(_state.priceToExtend, _state.monthToExtend,
          isPaymentComputed: true);
    else
      throw UnsupportedError("Тодорхойгүй state: $_state");
  }

  Widget _buildAppBar() {
    var _state = _bloc.currentState;
    if (_state is SelectedProductPreview)
      return AppBar(
        backgroundColor: Colors.white,
        title: _buildAppBarHeader(context, _state),
      );

    return PreferredSize(
      child: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _buildAppBarHeader(context, _state),
        titleSpacing: 10,
        elevation: 0,
        bottom: PreferredSize(
          child: Flexible(
            child: createTabBar,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.11),
    );
  }

  Widget _buildBody() {
    if (_bloc.currentState is Loading)
      return Center(child: CircularProgressIndicator());

    var _content = _buildContents();

    var _body =
        _createTabBarBody(_content, _bloc.currentState.selectedProductTab);

    if (_bloc.currentState is SelectedProductPreview) return _body;

    return Scaffold(
      appBar: _buildAppBar(),
      body: _body,
    );
  }

  Widget _createTabBarBody(Widget content, productSelectedTab) {
    return Stack(
      children: <Widget>[
        content,
        GestureDetector(onHorizontalDragEnd: (details) {
          double delta = details.velocity.pixelsPerSecond.dx;
          if (delta != 0.0) {
            bool isRight = delta < 0;

            if (_bloc.beforeState is ProductTabState ||
                _bloc.beforeState == null) {
              ProductTabType selectedTab =
                  (_bloc.currentState as ProductState).selectedProductTab;
              int currentTabIndex = ProductTabType.values.indexOf(selectedTab);

              int nextTabIndex = currentTabIndex + (isRight ? 1 : -1);

              if (nextTabIndex >= 0 && nextTabIndex < _productTabs.length) {
                TabMenuItem nextTab = _productTabs.elementAt(nextTabIndex);
                _tabController.animateTo(nextTabIndex);
                _bloc.dispatch(ProductTabChanged(nextTab.state));
              }
            } else
              _bloc.backToPrevState();
          }
        })
      ],
    );
  }
}
