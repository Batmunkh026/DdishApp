import 'dart:ui';

import 'package:ddish/src/blocs/menu/order/order_bloc.dart';
import 'package:ddish/src/blocs/menu/order/order_event.dart';
import 'package:ddish/src/blocs/menu/order/order_state.dart';
import 'package:ddish/src/models/district.dart';
import 'package:ddish/src/models/order.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/repositiories/menu_repository.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:ddish/src/widgets/submit_button.dart';
import 'package:ddish/src/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    Constants.districtItems
        .forEach((district) => dropDownItems.add(DropdownMenuItem(
              value: district,
              child: Text(
                district.name.toUpperCase(),
              ),
            )));
    _repository = MenuRepository();
    _bloc = OrderBloc(repository: _repository);
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
              .addPostFrameCallback((_) => showMessage(state.result));
        }
        return Container(
          height: height * 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Захиалга өгөгчийн мэдээлэл:",
                  style: const TextStyle(
                      color: const Color(0xffe4f0ff),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: Column(
                  children: <Widget>[
                    InputField(
                      placeholder: 'НЭР',
                      align: TextAlign.center,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      textController: _usernameController,
                    ),
                    InputField(
                      align: TextAlign.center,
                      placeholder: 'УТАСНЫ ДУГААР',
                      textInputType: TextInputType.number,
                      padding: const EdgeInsets.only(bottom: 10.0),
                      textController: _phoneController,
                    ),
                    DropdownButton(
                      iconEnabledColor: Color(0xffa4cafb),
                      value: selectedDistrict,
                      items: dropDownItems,
                      hint: Text(
                        'ДҮҮРЭГ СОНГОХ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xffa4cafb),
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0,
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => selectedDistrict = value),
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
            ],
          ),
        );
      },
    );
  }

  showMessage(Result result) {
    List<Widget> actions = new List();
    ActionButton closeDialog = ActionButton(title: 'Хаах', onTap: () => Navigator.pop(context),);
    actions.add(closeDialog);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: CustomDialog(
              title: Text('Санамж',
                  textAlign: TextAlign.center,
                  style: style.dialogTitleStyle),
              content: Text(result.resultMessage, style: style.messageStyle,),
              actions: actions,
            ),
          );
        });
  }

  onOrderTap() {
    Order order = Order(
      orderType: widget.orderType,
      userName: _usernameController.text,
      phoneNo: _phoneController.text,
      districtCode: selectedDistrict.id,
    );
    _bloc.dispatch(OrderTapped(order: order));
  }
}
