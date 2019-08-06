import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/blocs/service/service_bloc.dart';
import 'package:ddish/src/models/design.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/templates/service/product/underlined_text.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/utils/price_format.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPaymentPreview extends StatefulWidget {
  ProductPaymentPreview();

  @override
  State<StatefulWidget> createState() => ProductPaymentPreviewState();
}

class ProductPaymentPreviewState extends State<ProductPaymentPreview> {
  ProductBloc _bloc;
  ServiceBloc _serviceBloc;
  var _state;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ProductBloc>(context);
    _serviceBloc = BlocProvider.of<ServiceBloc>(context);
    _state = _bloc.currentState;

    if (_state is ProductPaymentState)
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => openResultDialog(context, _state as ProductPaymentState));
  }

  @override
  Widget build(BuildContext context) {
    var fontSize = MediaQuery.of(context).size.aspectRatio * 30;
    var titles = ["Багц", "Хугацаа", "Дүн"];
    List<Widget> contentsForGrid = [];
    var style = TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xff071f49),
//        fontSize: fontSize,
        fontFamily: 'Montserrat');

    var boldStyle = TextStyle(
        fontWeight: FontWeight.bold,
//        fontSize: fontSize,
        fontFamily: 'Montserrat');

    contentsForGrid.addAll(titles.map((title) => Text("$title")).toList());

    var isUpgrade = _state.selectedProductTab == ProductTabType.UPGRADE;
    var isUpgradeOrChannel =
        _state.selectedProductTab == ProductTabType.ADDITIONAL_CHANNEL ||
            isUpgrade;

    contentsForGrid.add(
      Align(
        alignment: Alignment.topCenter,
        child: isUpgradeOrChannel
            ? CachedNetworkImage(
                imageUrl: _state.selectedProduct.image,
                placeholder: (context, url) => Text(
                  _state.selectedProduct.name,
                  style: style,
                ),
                fit: BoxFit.contain,
              )
            : Text(
                _state.selectedProduct.name,
                style: boldStyle,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
      ),
    );
    contentsForGrid.add(Text("${_state.monthToExtend} сар", style: boldStyle));

//      TODO сонгосон сарын сарын төлбөрийг яаж бодох ???
    contentsForGrid.add(Text(
        "₮${PriceFormatter.productPriceFormat(isUpgrade ? _state.priceToExtend : _state.monthToExtend * _state.priceToExtend)}",
        style: boldStyle));

//    if (state is ProductPaymentState)
//      openResultDialog(context, state as ProductPaymentState);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
//                  textStyle: TextStyle(fontSize: fontSize),
                      underlineWidth: 1,
                    ),
                    Divider(),
                  ],
                ),
                onPressed: _bloc.backToPrevState,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: GridView.count(
                  padding: EdgeInsets.only(left: 40),
                  childAspectRatio: 2,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  children: contentsForGrid,
                ),
              ),
              FlatButton(
                child: UnderlinedText("Үндсэн дансаар"),
                onPressed: () => {},
              ),
            ],
          ),
          Center(
            child: SubmitButton(
                text: "Сунгах",
                padding: EdgeInsets.only(top: 20),
                onPressed: () => _bloc.dispatch(ExtendSelectedProduct(
                    _state.selectedProductTab,
                    _state.selectedProduct,
                    _state.monthToExtend,
                    _state.priceToExtend)),
                verticalMargin: 0,
                horizontalMargin: 0),
          ),
          Divider()
        ],
      ),
    );
  }

  ///бүтээгдэхүүн сунгах төлбөр төлөлтийн үр дүн харуулах
  openResultDialog(BuildContext context, ProductPaymentState state) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            important: true,
            //TODO title руу String утга дамжуулаад style ыг нь Dialog дотор хийх
            title: state.isSuccess ? 'Мэдэгдэл' : 'Анхааруулга',
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
            closeButtonText: state.isSuccess ? 'Хаах' : 'Болих',
            submitButtonText: state.isSuccess ? null : 'Цэнэглэх',
            onSubmit: () {
              //close dialog
              Navigator.pop(context);
              //navigate to Account Tab
              _serviceBloc.chargeAccount();
            },
            onClose: state.isSuccess
                ? () {
                    Navigator.pop(context);
                    _bloc.dispatch(ProductTabChanged(state.selectedProductTab));
                  }
                : null,
          );
        });
  }

  List<TextSpan> createContent(ProductPaymentState state) {
    if (!state.isSuccess) return [TextSpan(text: state.resultMessage)];

    bool isChannel =
        state.selectedProductTab == ProductTabType.ADDITIONAL_CHANNEL;
    bool isUpgrade = state.selectedProductTab == ProductTabType.UPGRADE;

    var resultText = isChannel
        ? 'түрээслэлээ'
        : (isUpgrade
            ? 'ахиуллаа'
            : 'сунгалаа');

    var boldStyle = TextStyle(fontWeight: FontWeight.w600);

    return [
      TextSpan(text: 'Та '),
      TextSpan(text: "${state.productToExtend.name} ", style: boldStyle),
      TextSpan(text: isChannel ? 'сувгийг ' : ''),
      TextSpan(text: '${state.monthToExtend} ', style: boldStyle),
      TextSpan(text: 'сараар '),
      TextSpan(text: '${isUpgrade ? state.priceToExtend : state.priceToExtend*state.monthToExtend} ₮ ', style: boldStyle),
      TextSpan(text: ' төлөн амжилттай $resultText.')
    ];
  }
}
