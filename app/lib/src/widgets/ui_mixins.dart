import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:flutter/material.dart';

mixin WidgetMixin {
  openPermissionDialog(bloc, context, ProductEvent event, monthToExtend) {
//Багц сунгах төлбөр төлөлтийн үр дүн
    CustomDialog paymentResultDialog = CustomDialog(
      title: 'Анхааруулга',
      submitButtonText: 'Тийм',
      onSubmit: () => _confirmed(bloc, context, event),
      closeButtonText: 'Үгүй',
      content: Text(Constants.createPermissionContentStr(
          bloc.currentState.selectedProductTab,
          bloc.currentState.selectedProduct.name,
          monthToExtend,
          bloc.currentState.selectedProduct.price * monthToExtend)),
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
