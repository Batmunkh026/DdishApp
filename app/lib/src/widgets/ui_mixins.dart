import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:flutter/material.dart';

mixin WidgetMixin {
  openPermissionDialog(ProductBloc bloc, context, ProductEvent event,
      productName, monthToExtend, price) {
    var totalPriceToExtend =
        bloc.currentState.selectedProductTab == ProductTabType.UPGRADE
            ? price
            : price * monthToExtend;

//Багц сунгах төлбөр төлөлтийн үр дүн
    ActionButton chargeAccountBtn = ActionButton(
        title: 'Тийм', onTap: () => _confirmed(bloc, context, event));
    ActionButton closeDialog =
        ActionButton(title: 'Үгүй', onTap: () => Navigator.pop(context));

    CustomDialog paymentResultDialog = CustomDialog(
      title: Text('Анхааруулга',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: const Color(0xfffcfdfe),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 15.0)),
      content: Text(Constants.createPermissionContentStr(
          bloc.currentState.selectedProductTab,
          productName,
          monthToExtend,
          totalPriceToExtend)),
      actions: [chargeAccountBtn, closeDialog],
    );
//    paymentResultDialog.
    var dialog = paymentResultDialog;
    showDialog(context: context, builder: (context) => dialog);
  }

  _confirmed(bloc, context, ProductEvent event) {
    Navigator.pop(context);
    bloc.dispatch(event);
  }
}
