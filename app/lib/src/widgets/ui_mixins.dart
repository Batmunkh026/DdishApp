import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:flutter/material.dart';

mixin WidgetMixin {
  openPermissionDialog(bloc, context, PackEvent event, item) {
//Багц сунгах төлбөр төлөлтийн үр дүн
    ActionButton chargeAccountBtn = ActionButton(
        title: 'Тийм', onTap: () => _confirmed(bloc, context, event));
    ActionButton closeDialog =
        ActionButton(title: 'Үгүй', onTap: () => Navigator.pop(context));

    CustomDialog paymentResultDialog = CustomDialog(
      title: 'Анхааруулга',
      content: Text(Constants.createPermissionContentStr(
          bloc.currentState.selectedTab, bloc.currentState.selectedPack.productName, item.monthToExtend, item.price)),
      actions: [chargeAccountBtn, closeDialog],
    );
//    paymentResultDialog.
    var dialog = paymentResultDialog;
    showDialog(context: context, builder: (context) => dialog);
  }

  _confirmed(bloc, context, PackEvent event) {
    Navigator.pop(context);
    bloc.dispatch(event);
  }
}
