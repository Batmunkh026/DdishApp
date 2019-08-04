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
import 'package:logging/logging.dart';

class ProductPage extends StatefulWidget {
  double height;
  ProductPage(this.height);

  @override
  State<StatefulWidget> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  final Logger log = new Logger('ProductPageState');
  ProductBloc _bloc;

  var _productTabs = Constants.productTabs;

  TabController _tabController;

  bool updateAppBar = true;
  var defaultAppBar;

  double appBarHeight = 0;
  double contentContainerHeight = 0;

  MediaQueryData queryData;
  double fontSize = 0;

  @override
  void initState() {
    _bloc = ProductBloc(this);
    _tabController = TabController(length: _productTabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    fontSize = queryData.size.width * 0.02 + 5;

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
    var fontStyle = TextStyle(
        color: const Color(0xff071f49),
        fontWeight: FontWeight.w500,
        fontSize: fontSize);

    var productExpireDate = _bloc.getExpireDateOfUserSelectedProduct();

    var productAppBarContent;
    if (_bloc.currentState is Loading && productExpireDate == null)
      productAppBarContent = Container(
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: CircularProgressIndicator(),
          ),
        ),
        height: 25,
      );
    else {
      updateAppBar = false;

      productAppBarContent = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 35,
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
                  "${DateUtil.formatProductDate(productExpireDate)}",
                  style: TextStyle(
                    color: Color(0xff071f49),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: fontSize * 1.1,
                  ),
                ),
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
        productAppBarContent.children.add(_createProductPicker(state));
    }
    return PreferredSize(
      preferredSize: Size(queryData.size.width, 38),
      child: productAppBarContent,
    );
  }

  Widget _createProductPicker(ProductState state) {
    List<Product> items = _bloc.products;
    double pickerWidth = queryData.size.width * 0.22;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        DropdownButton(
          iconSize: 0,
          isDense: true,
          underline: Container(),
          items: items
              .map((product) => DropdownMenuItem<Product>(
                  value: product,
                  child: Container(
                    height: 28,
                    width: pickerWidth,
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(),
                        ),
                      ),
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
        Container(
          height: 10,
          child: Icon(
            Icons.arrow_drop_down,
            color: Color.fromRGBO(48, 105, 178, 1),
          ),
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
    double containerHeight = widget.height - appBarHeight;
    var _state = _bloc.currentState;

    if (_state is Loading) return Center(child: CircularProgressIndicator());

    if (_state is ProductTabState || _state is ProductSelectionState) {
      if (_bloc.backState is SelectedProductPreview) createDefaultAppBar();

      //багц сунгах бол сонгосон багцыг , бусад таб бол боломжит бүх багцуудыг
      var itemsForGrid = _state.selectedProductTab == ProductTabType.EXTEND
          ? _state.selectedProduct
          : _state.initialItems;
      var productPicker = ProductGridPicker(itemsForGrid, containerHeight);
      return productPicker;
    } else if (_state is AdditionalChannelState) {
      //нэмэлт суваг сонгосон төлөв
      return ProductGridPicker(_state.selectedProduct, containerHeight);
    } else if (_state is SelectedProductPreview ||
        _state is ProductPaymentState) {
      updateAppBar = true;
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

    var _appBar = _state is SelectedProductPreview
        ? AppBar(
            backgroundColor: Colors.white,
            title: _buildAppBarHeader(context, _state),
          )
        : defaultAppBar;

    appBarHeight = _appBar.preferredSize.height;
    return _appBar;
  }

  Widget _buildBody() {
    if (updateAppBar) createDefaultAppBar();

    var _appBar = _buildAppBar();

    var _content = _buildContents();

    var _body =
        _createTabBarBody(_content, _bloc.currentState.selectedProductTab);

    if (_bloc.currentState is SelectedProductPreview) return _body;

    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }

  Widget _createTabBarBody(Widget content, productSelectedTab) {
    return Stack(
      children: <Widget>[
        content,
        GestureDetector(onHorizontalDragEnd: (details) {
          if (_bloc.currentState is Loading) return;
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

  void createDefaultAppBar() {
    var prefSize = Size(queryData.size.width, 84);
    defaultAppBar = PreferredSize(
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: prefSize,
          child: Column(
            children: <Widget>[
              _buildAppBarHeader(context, _bloc.currentState),
              createTabBar()
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      preferredSize: prefSize,
    );
  }

  createTabBar() {
    return PreferredSize(
      child: TabBar(
        isScrollable: true,
        controller: _tabController,
        tabs: _productTabs.map((tabItem) => Tab(text: tabItem.title)).toList(),
        onTap: (tabIndex) {
          if (!(_bloc.currentState is Loading))
            _bloc.dispatch(ProductTabChanged(_productTabs[tabIndex].state));
        },
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        labelColor: Color(0xff071f49),
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize),
        indicatorColor: Color(0xFF3069b2),
      ),
      preferredSize: Size(queryData.size.width, 25),
    );
  }
}
