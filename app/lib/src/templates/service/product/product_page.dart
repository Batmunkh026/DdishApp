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
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatefulWidget {
  ServiceBloc serviceBloc;
  ProductPage(this.serviceBloc);

  @override
  State<StatefulWidget> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  ProductBloc bloc;

  var productTabs = Constants.productTabs;

  TabController tabController;

  get createTabBar => TabBar(
        isScrollable: true,
        controller: tabController,
        tabs: productTabs
            .map((tabItem) => Tab(
                child: Text(tabItem.title,
                    style: TextStyle(
                        color: Color(0xff071f49),
                        fontSize: 12,
                        fontWeight: FontWeight.w600))))
            .toList(),
        onTap: (tabIndex) =>
            bloc.dispatch(ProductTabChanged(productTabs[tabIndex].state)),
        indicatorColor: Color.fromRGBO(48, 105, 178, 1),
      );
  @override
  void initState() {
    bloc = ProductBloc();
    tabController = TabController(length: productTabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, ProductState state) {
          return BlocProviderTree(blocProviders: [
            BlocProvider<ServiceBloc>(
              bloc: widget.serviceBloc,
            ),
            BlocProvider<ProductBloc>(
              bloc: bloc,
            ),
          ], child: buildBody());
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
                  "${DateUtil.formatProductDate(bloc.getExpireDateOfUserSelectedProduct())}",
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
      padding: EdgeInsets.all(8),
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

    if (_state is ProductTabState || _state is ProductSelectionState) {
      //багц сунгах бол сонгосон багцыг , бусад таб бол боломжит бүх багцуудыг
      var itemsForGrid = _state.selectedProductTab == ProductTabType.EXTEND
          ? _state.selectedProduct
          : _state.initialItems;
      var productPicker = ProductGridPicker(bloc, itemsForGrid);
      return productPicker;
    } else if (_state is AdditionalChannelState) {
      //нэмэлт суваг сонгосон төлөв
      return ProductGridPicker(bloc, _state.selectedProduct);
    } else if (_state is SelectedProductPreview ||
        _state is ProductPaymentState) {
      return ProductPaymentPreview(bloc, _state);
    } else if (_state is CustomProductSelector)
      return CustomProductChooser(bloc, _state.priceToExtend, 0);
    else if (_state is CustomMonthState)
      return CustomProductChooser(
          bloc, _state.priceToExtend, _state.monthToExtend,
          isPaymentComputed: true);
    else
      throw UnsupportedError("Тодорхойгүй state: $_state");
  }

  Widget buildAppBar() {
    var _state = bloc.currentState;
    if (_state is SelectedProductPreview)
      return AppBar(
        backgroundColor: Colors.white,
        title: buildAppBarHeader(context, _state),
      );

    return PreferredSize(
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: buildAppBarHeader(context, _state),
          titleSpacing: 10,
          elevation: 0,
          bottom: PreferredSize(
              child: Container(
                child: createTabBar,
              ),
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.03)),
          backgroundColor: Colors.white,
        ),
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.12));
  }

  Widget buildBody() {
    if (bloc.currentState is Loading)
      return Center(child: CircularProgressIndicator());

    var content = buildContents();

    var body = createTabBarBody(content);

    if (bloc.currentState is SelectedProductPreview) return body;

    return Scaffold(
      appBar: buildAppBar(),
      body: body,
    );
  }

  Widget createTabBarBody(Widget content) {
    return Stack(
      children: <Widget>[
        content,
        GestureDetector(onHorizontalDragEnd: (details) {
          double delta = details.velocity.pixelsPerSecond.dx;
          if (delta != 0.0) {
            bool isRight = delta < 0;

            ProductTabType selectedTab =
                (bloc.currentState as ProductState).selectedProductTab;
            int currentTabIndex = ProductTabType.values.indexOf(selectedTab);

            int nextTabIndex = currentTabIndex + (isRight ? 1 : -1);

            if (nextTabIndex >= 0 && nextTabIndex < productTabs.length) {
              TabMenuItem nextTab = productTabs.elementAt(nextTabIndex);
              tabController.animateTo(nextTabIndex);
              bloc.dispatch(ProductTabChanged(nextTab.state));
            }
          }
        })
      ],
    );
  }
}
