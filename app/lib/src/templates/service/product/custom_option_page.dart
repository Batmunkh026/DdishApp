import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/models/design.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/utils/converter.dart';
import 'package:ddish/src/utils/input_validations.dart';
import 'package:ddish/src/utils/price_format.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:ddish/src/widgets/ui_mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomProductChooser extends StatefulWidget {
  int priceToExtend;
  int monthToExtend = 1;
  bool isPaymentComputed;

  CustomProductChooser(this.priceToExtend, this.monthToExtend,
      {this.isPaymentComputed = false});

  @override
  State<StatefulWidget> createState() => CustomProductChooserState();
}

class CustomProductChooserState extends State<CustomProductChooser>
    with WidgetMixin {
  ProductBloc _bloc;
  String paymentPreview = '0';
  int month;
  TextEditingController monthEditingController;

  CustomProductChooserState() {
    monthEditingController = TextEditingController();

    monthEditingController.addListener(() {
      var value = monthEditingController.text;
      bool isEmptyOrNull = value == null || value.isEmpty;

      if (value != '${month}') {
        if (isEmptyOrNull || value == '0') {
          setState(() {
            paymentPreview = "";
            month = 0;
          });
        } else {
          month = Converter.toInt(value);
          if (_bloc.currentState.selectedProductTab ==
              ProductTabType.UPGRADE) //server ээс авах
            _bloc.dispatch(CustomMonthChanged(
                _bloc.currentState.selectedProductTab,
                _bloc.selectedProduct,
                _bloc.currentState.selectedProduct,
                month));
          else
            setState(
                () => paymentPreview = "${(month * widget.priceToExtend)}");
        }
      }
      print("month value: " + value);
    });
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<ProductBloc>(context);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var state = _bloc.currentState;

    if (widget.isPaymentComputed) {
      paymentPreview = "${widget.priceToExtend}";
      month = widget.monthToExtend;

      var monthStr = "${month == null ? '' : month}";
      if (state.selectedProductTab == ProductTabType.UPGRADE)
        monthEditingController.text = monthStr;
      widget.isPaymentComputed = false;
    }

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
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CachedNetworkImage(
                  imageUrl: state.selectedProduct.image,
                  placeholder: (context, url) => Text(
                    state.selectedProduct.name,
                    softWrap: true,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(width: MediaQuery.of(context).size.width, child: label)
          ])
        : label;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Center(
          child: Form(
            key: _formKey,
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  FlatButton(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        Align(
                          child: Constants.appIcons[AppIcons.Back],
                          alignment: Alignment.centerLeft,
                        ),
                        Align(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: backComponent,
                            padding: EdgeInsets.only(bottom: 10),
                          ),
                          alignment: Alignment.topCenter,
                        ),
                      ],
                    ),
                    //TODO back to previous page
                    onPressed: _bloc.backToPrevState,
                  ),
                  Center(
                      child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.055,
                        padding: EdgeInsets.only(top: 5),
                        child: InputField(
                          hasBorder: true,
                          align: TextAlign.center,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            InputValidations
                                .acceptedFormatters[InputType.NumberInt],
                            WhitelistingTextInputFormatter(
                                RegExp(r'(^1[0-2]$)|(^[0-9]$)'))
                          ],
                          textController: monthEditingController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          "Сунгах сарын үнийн дүн",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                            "₮${PriceFormatter.productPriceFormat(paymentPreview)}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SubmitButton(
                          text: "Сунгах",
                          onPressed: () => _toExtend(state),
                          verticalMargin: 0,
                          horizontalMargin: 0)
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _toExtend(state) {
    if (widget.isPaymentComputed) month = widget.monthToExtend;
    if (month == null || month == 0) return;

    var event = PreviewSelectedProduct(state.selectedProductTab,
        state.selectedProduct, month, widget.priceToExtend);

    var productName =
        _bloc.currentState.selectedProductTab == ProductTabType.EXTEND
            ? _bloc.selectedProduct.name
            : state.selectedProduct.name;

    openPermissionDialog(
        _bloc, context, event, productName, month, widget.priceToExtend);
  }

  @override
  void dispose() {
    monthEditingController.dispose();
    super.dispose();
  }
}
