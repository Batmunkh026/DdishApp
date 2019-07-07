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

class CustomProductChooser extends StatefulWidget {
  ProductBloc _bloc;
  int priceToExtend;
  int monthToExtend;
  bool isPaymentComputed;

  CustomProductChooser(this._bloc, this.priceToExtend, this.monthToExtend,
      {this.isPaymentComputed = false});

  @override
  State<StatefulWidget> createState() => CustomProductChooserState();
}

class CustomProductChooserState extends State<CustomProductChooser>
    with WidgetMixin {
  String paymentPreview = '0';
  int month;
  StreamController<int> monthStreamController = StreamController();

  CustomProductChooserState() {
    monthStreamController.stream.listen((month) {
      this.month = month;
      if (widget._bloc.currentState.selectedProductTab ==
          ProductTabType.UPGRADE) //server ээс авах
        widget._bloc.dispatch(CustomMonthChanged(
            widget._bloc.currentState.selectedProductTab,
            widget._bloc.selectedProduct,
            widget._bloc.currentState.selectedProduct,
            month));
      else
        paymentPreview = "${(month * widget.priceToExtend)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPaymentComputed) {
      paymentPreview = "${widget.priceToExtend}";
      month = widget.monthToExtend;
    }

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
              height: MediaQuery.of(context).size.height * 0.08,
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.all(8),
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
              onPressed: widget._bloc.backToPrevState,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.055,
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: InputField(
                hasBorder: true,
                align: TextAlign.center,
                initialValue: '${month == null ? '' : month}',
                textInputType: TextInputType.text,
                inputFormatters: [
                  InputValidations.acceptedFormatters[InputType.NumberInt]
                ],
                onFieldSubmitted: (value) =>
                    monthStreamController.add(Converter.toInt(value)),
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

  toExtend(state) {
    if (widget.isPaymentComputed) month = widget.monthToExtend;

    var event = PreviewSelectedProduct(state.selectedProductTab,
        state.selectedProduct, month, widget.priceToExtend);

    openPermissionDialog(widget._bloc, context, event,
        widget._bloc.selectedProduct.name, month, widget.priceToExtend);
  }

  @override
  void dispose() {
    monthStreamController.close();
    super.dispose();
  }
}
