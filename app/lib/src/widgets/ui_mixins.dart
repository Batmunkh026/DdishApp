import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:flutter/material.dart';

mixin WidgetMixin {
  openPermissionDialog(ProductBloc bloc, context, ProductEvent event,
      productName, monthToExtend, price) {

    var totalPriceToExtend = bloc.currentState.selectedProductTab == ProductTabType.UPGRADE
        ? price
        : price * monthToExtend;

//Багц сунгах төлбөр төлөлтийн үр дүн
    CustomDialog paymentResultDialog = CustomDialog(
      title: 'Анхааруулга',
      submitButtonText: 'Тийм',
      onSubmit: () => _confirmed(bloc, context, event),
      closeButtonText: 'Үгүй',
      content: Text(Constants.createPermissionContentStr(
          bloc.currentState.selectedProductTab,
          productName,
          monthToExtend,
          totalPriceToExtend))
    );
//    paymentResultDialog.
    var dialog = paymentResultDialog;
    showDialog(context: context, builder: (context) => dialog);
  }

  _confirmed(ProductBloc bloc, context, ProductEvent event) {
    Navigator.pop(context);
    bloc.dispatch(event);
  }
}
