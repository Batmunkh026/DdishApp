import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/blocs/service/service_bloc.dart';
import 'package:ddish/src/blocs/service/service_event.dart';
import 'package:ddish/src/models/design.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/templates/service/product/underlined_text.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/utils/price_format.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    var isUpgrade = state.selectedProductTab == ProductTabType.UPGRADE;
    var isUpgradeOrChannel =
        state.selectedProductTab == ProductTabType.ADDITIONAL_CHANNEL ||
            isUpgrade;

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
        "₮${PriceFormatter.productPriceFormat(isUpgrade ? state.priceToExtend : state.monthToExtend * state.priceToExtend)}",
        style: boldStyle));

    if (state is ProductPaymentState)
      openResultDialog(context, state as ProductPaymentState);

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
                  state.monthToExtend,
                  state.priceToExtend)),
              verticalMargin: 0,
              horizontalMargin: 0)
        ],
      ),
    );
  }

  ///бүтээгдэхүүн сунгах төлбөр төлөлтийн үр дүн харуулах
  void openResultDialog(BuildContext context, ProductPaymentState state) async {
    List<Widget> actions = new List();

    if (!state.isSuccess) {
      actions.add(
        ActionButton(
          title: 'Цэнэглэх',
          onTap: () {
            //TODO navigate to Account Tab
            var serviceBloc = BlocProvider.of<ServiceBloc>(context);
            var event = ServiceTabSelected(Constants.serviceTabs[0].state);
            serviceBloc.dispatch(event);
          },
        ),
      );
    }
    actions.add(
      ActionButton(
        title: state.isSuccess ? 'Хаах' : 'Болих',
        onTap: () => Navigator.pop(context),
      ),
    );

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            important: true,
            //TODO title руу String утга дамжуулаад style ыг нь Dialog дотор хийх
            title: Text(state.isSuccess ? 'Мэдэгдэл' : 'Анхааруулга',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xfffcfdfe),
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0)),
            content: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                    color: const Color(0xffe4f0ff),
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                //TODO children ыг дамжуулаад Container ыг Dialog дотор оруулж өгөх
                children: createContent(state),
              ),
            ),
            actions: actions,
          );
        });
  }

  List<TextSpan> createContent(ProductPaymentState state) {
    if (!state.isSuccess) return [TextSpan(text: state.resultMessage)];

    bool isChannel =
        state.selectedProductTab == ProductTabType.ADDITIONAL_CHANNEL;

    var boldStyle = TextStyle(fontWeight: FontWeight.w600);

    return [
      TextSpan(text: 'Та '),
      TextSpan(text: "${state.productToExtend.name} ", style: boldStyle),
      TextSpan(text: isChannel ? 'сувгийг ' : 'багцыг'),
      TextSpan(text: '${state.monthToExtend} ', style: boldStyle),
      TextSpan(text: 'сараар '),
      TextSpan(text: '${state.priceToExtend} ₮ ', style: boldStyle),
      TextSpan(
          text: ' төлөн амжилттай ${isChannel ? 'түрээслэлээ' : 'сунгалаа'}.')
    ];
  }
}
