import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/utils/converter.dart';
import 'package:ddish/src/utils/input_validations.dart';
import 'package:ddish/src/utils/formatter.dart';
import 'package:ddish/src/widgets/product_back_btn.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:ddish/src/widgets/ui_mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// сарын мэдээллийг хэрэглэгч өөрөө оруулахад ашиглах UI
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
          setState(() => paymentPreview = "${(month * widget.priceToExtend)}");
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
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

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

    monthEditingController.selection =
        TextSelection.collapsed(offset: monthEditingController.text.length);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.transparent,
            width: isUpgradeOrChannel ? deviceWidth * 0.7 : deviceWidth * 0.8,
            child: Form(
              key: _formKey,
              child: Column(
//                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    child: isUpgradeOrChannel
                        ? ProductBackBtn(
                            "Сунгах сарын тоогоо оруулна уу",
                            onTap: () => _bloc.backToPrevState(),
                            productImage: state.selectedProduct.image,
                            productName: state.selectedProduct.name,
                          )
                        : ProductBackBtn(
                            "Сунгах сарын тоогоо оруулна уу",
                            onTap: () => _bloc.backToPrevState(),
                          ),
                    height: deviceWidth * 0.15,
                  ),
                  Visibility(
                    child: Divider(
                      height: deviceWidth * 0.13,
                      color: Colors.transparent,
                    ),
                    visible: isUpgradeOrChannel,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: deviceWidth * 0.38,
//                          margin: EdgeInsets.only(top: ),
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
                        Container(
                          width:
                              deviceWidth * (isUpgradeOrChannel ? 0.5 : 0.44),
                          child: FittedBox(
                            child: Text(
                              "Сунгах сарын үнийн дүн",
                            ),
                            fit: BoxFit.contain,
                          ),
                          margin: EdgeInsets.only(bottom: 5, top: 15),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(
                            "₮${PriceFormatter.productPriceFormat(paymentPreview)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          child: SubmitButton(
                              text: "Сунгах",
                              onPressed: () => _toExtend(state),
                              verticalMargin: 0,
                              horizontalMargin: 0),
                          width: deviceWidth * 0.3,
                          height: 25 + deviceWidth * 0.01,
                        )
                      ],
                    ),
                  ),
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
