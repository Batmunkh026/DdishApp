import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/presentation/ddish_flutter_app_icons.dart';
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
import 'package:ddish/src/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';


///Бүтээгдэхүүний ерөнхий хуудас
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

  double contentContainerHeight = 0;

  MediaQueryData queryData;
  double fontSize = 11;

  @override
  void initState() {
    _bloc = ProductBloc(this);
    _tabController = TabController(length: _productTabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    fontSize = queryData.size.width * 0.02 +
        (MediaQuery.of(context).size.width < 340 ? 5 : 7);

    var _serviceBloc = BlocProvider.of<ServiceBloc>(context);
    return BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, ProductState state) {
          if (state is Started) _bloc.initialize();

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

    List<Widget> activeProductStatusChildren = [
      new Text("Идэвхтэй багц", style: fontStyle)
    ];

    if (_bloc.currentState is Started ||
        _bloc.currentState is Loading && productExpireDate == null)
      productAppBarContent = Center(
        child: CircularProgressIndicator(),
      );
    else {
      productAppBarContent = Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: activeProductStatusChildren,
          ),
          Row(children: [
            new Text("Дуусах хугацаа: ", style: fontStyle),
            Text(
              "${DateUtil.formatProductDate(productExpireDate)}",
              style: TextStyle(
                color: Color(0xff071f49),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: fontSize,
              ),
            ),
          ])
        ],
      );

      if (state is SelectedProductPreview)
        return Text("Сунгах");
      else if (state is ProductTabState ||
          state is CustomProductSelector ||
          state is ProductSelectionState)
        activeProductStatusChildren.add(
          Container(
            transform:
                Transform.translate(offset: Offset(0, fontSize / 2)).transform,
            child: _createProductPicker(state),
          ),
        );
    }

    var deviceWidth = queryData.size.width;
    var scalar = deviceWidth > 400 ? 0.83 : 0.9;
    return Container(
      padding: EdgeInsets.all(5),
      width: deviceWidth < 380 ? deviceWidth : deviceWidth * scalar,
      child: productAppBarContent,
    );
  }

  Widget _createProductPicker(ProductState state) {
    List<Product> items = _bloc.products;
    var pickerWidth = queryData.size.width * 0.2;

    Product activeProduct = _bloc.getUserActiveProduct();

    if (state.selectedProductTab == ProductTabType.EXTEND)
      activeProduct =
          _bloc.selectedProduct == null ? items.first : _bloc.selectedProduct;

    if (activeProduct == null) return Container();

    Selector<Product> productPicker = Selector<Product>(
        initialValue: activeProduct,
        items: items,
        iconFontSize: fontSize - 3,
        icon: DdishAppIcons.arrow_down,
        iconColor: Color(0xff3069b2),
        isIconOnBottom: true,
        onSelect: state.selectedProductTab != ProductTabType.EXTEND
            ? null
            : (value) => _bloc.dispatch(
                ProductTypeSelectorClicked(state.selectedProductTab, value)),
        pickerWidth: pickerWidth,
        dropdownChildPadding: EdgeInsets.only(top: 8, bottom: 8),
        childMap: (p) {
          return CachedNetworkImage(
            imageUrl: p.image,
            placeholder: (context, url) => Center(
              child: SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(),
              ),
            ),
            fit: BoxFit.contain,
          );
        });

    return productPicker;
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildContents() {
    double containerHeight = widget.height;
    var _state = _bloc.currentState;

    if (_state is Loading || _state is Started)
      return Center(child: CircularProgressIndicator());

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

    if (updateAppBar) createDefaultAppBar();

    var _appBar = _state is SelectedProductPreview
        ? Container(
            child: _buildAppBarHeader(context, _state),
          )
        : AbsorbPointer(
            child: defaultAppBar,
            absorbing: _state is Loading || _state is Started,
          );
    return _appBar;
  }

  Widget _buildBody() {
    if (_bloc.currentState is ProductTabState ||
        _bloc.currentState is ProductSelectionState) updateAppBar = true;

    var _appBar = _buildAppBar();

    var _content = _buildContents();

    var _body =
        _createTabBarBody(_content, _bloc.currentState.selectedProductTab);

    if (_bloc.currentState is SelectedProductPreview ||
        _bloc.currentState is ProductPaymentState) return _body;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
          child: Column(
        children: [
          _appBar,
          Expanded(
            child: _body,
          ),
        ],
      )),
    );
  }

  Widget _createTabBarBody(Widget content, productSelectedTab) {
    return Stack(
      children: <Widget>[
        content,
        GestureDetector(onHorizontalDragEnd: (details) {
          if (_bloc.currentState is Loading || _bloc.currentState is Started)
            return;
          double delta = details.velocity.pixelsPerSecond.dx;
          if (delta != 0.0) {
            bool isRight = delta < 0;

            if (_bloc.beforeState is ProductTabState ||
                _bloc.currentState is ProductSelectionState ||
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
            } else if (delta > 0) _bloc.backToPrevState();
          }
        })
      ],
    );
  }

  void createDefaultAppBar() {
    if (!(_bloc.currentState is Loading || _bloc.currentState is Started))
      updateAppBar = false;
//    var prefSize = Size(queryData.size.width, 84);
    defaultAppBar = Column(
      children: <Widget>[
        _buildAppBarHeader(context, _bloc.currentState),
        createTabBar()
      ],
    );
  }

  createTabBar() {
    return PreferredSize(
      child: TabBar(
        indicatorPadding: EdgeInsets.symmetric(vertical: 6),
        isScrollable: true,
        controller: _tabController,
        tabs: _productTabs.map((tabItem) => Tab(text: tabItem.title)).toList(),
        onTap: (tabIndex) {
          _bloc.dispatch(ProductTabChanged(_productTabs[tabIndex].state));
        },
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        labelColor: Color(0xff071f49),
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize),
        indicatorColor: Color(0xFF3069b2),
      ),
      preferredSize: Size(queryData.size.width, 25),
    );
  }
}
