import 'package:ddish/src/blocs/service/pack/pack_event.dart';
import 'package:ddish/src/blocs/service/pack/pack_state.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:ddish/src/widgets/dialog.dart';
import 'package:ddish/src/widgets/dialog_action.dart';
import 'package:flutter/material.dart';

mixin WidgetMixin {
  openPermissionDialog(bloc, context, PackEvent event, monthToExtend) {
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
          bloc.currentState.selectedTab, bloc.currentState.selectedPack.name, monthToExtend, bloc.currentState.selectedPack.price * monthToExtend)),
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
