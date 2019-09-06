import 'dart:ui';

import 'package:ddish/src/blocs/menu/order/order_bloc.dart';
import 'package:ddish/src/blocs/menu/order/order_event.dart';
import 'package:ddish/src/blocs/menu/order/order_state.dart';
import 'package:ddish/src/models/district.dart';
import 'package:ddish/src/models/order.dart';
import 'package:ddish/src/repositiories/menu_repository.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/utils/input_validations.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_picker.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'style.dart' as style;

class OrderWidget extends StatefulWidget {
  final String orderType;

  OrderWidget(this.orderType);

  @override
  State<StatefulWidget> createState() => OrderWidgetState();
}

class OrderWidgetState extends State<OrderWidget> {
  List<DropdownMenuItem> dropDownItems = List();
  MenuRepository _repository;
  OrderBloc _bloc;
  District selectedDistrict;
  bool submitError = false;
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Constants.districtItems
        .forEach((district) => dropDownItems.add(DropdownMenuItem(
              value: district,
              child: Center(child: Text(district.name.toUpperCase())),
            )));
    _repository = MenuRepository();
    _bloc = OrderBloc(this, repository: _repository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<OrderEvent, OrderState>(
      bloc: _bloc,
      builder: (BuildContext context, OrderState state) {
        if (state is OrderRequestFinished) {
          SchedulerBinding.instance
              .addPostFrameCallback((_) => showMessage(state));
        }

        return Expanded(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Center(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Text("Захиалга өгөгчийн мэдээлэл:",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: const Color(0xffe4f0ff),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0)),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InputField(
                            placeholder: 'НЭР',
                            align: TextAlign.center,
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            textController: _usernameController,
                            validateFunction: InputValidations.validateName,
                          ),
                          InputField(
                            inputFormatters: [
                              InputValidations
                                  .acceptedFormatters[InputType.NumberInt],
                              WhitelistingTextInputFormatter(
                                  RegExp(r'^[\d+]{0,8}$'))
                            ],
                            align: TextAlign.center,
                            placeholder: 'УТАСНЫ ДУГААР',
                            textInputType: TextInputType.number,
                            padding: const EdgeInsets.only(bottom: 10.0),
                            textController: _phoneController,
                            validateFunction:
                                InputValidations.validatePhoneNumber,
                          ),
                          DialogPickerButton(
                            pickerDialog: DialogPicker<District>(
                              title: "ДҮҮРЭГ СОНГОХ",
                              items: Constants.districtItems,
                              selectedItem: selectedDistrict,
                              itemMap: (district) => Text(district.name),
                              onSelect: (value) =>
                                  setState(() => selectedDistrict = value),
                              closeButtonText: "Хаах",
                            ),
                            textStyle: TextStyle(color: Color(0xffa4cafb)),
                            iconColor: Color(0xffa4cafb),
                          ),
                          !submitError
                              ? SizedBox.shrink()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Та дүүргээ сонгоно уу!',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xffd32f2f),
                                        fontSize: 12.0),
                                  ),
                                ),
                          SubmitButton(
                            padding: EdgeInsets.only(top: 30.0),
                            horizontalMargin: 35.0,
                            text: 'Захиалах',
                            onPressed: state is OrderRequestProcessing
                                ? null
                                : () => onOrderTap(),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showMessage(OrderRequestFinished state) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Санамж',
            closeButtonText: 'Хаах',
            onClose: () {
              Navigator.pop(context);
              _bloc.dispatch(OrderEdit(state.order));
            },
            content: Text(
              state.result.resultMessage,
              textAlign: TextAlign.center,
              style: style.messageStyle,
            ),
          );
        });
  }

  onOrderTap() {
    setState(() => submitError = selectedDistrict == null);
    if (_formKey.currentState.validate()) {
      Order order = Order(
        orderType: widget.orderType,
        userName: _usernameController.text,
        phoneNo: _phoneController.text,
        districtCode: selectedDistrict.id,
      );
      _bloc.dispatch(OrderTapped(order: order));
    }
  }
}
