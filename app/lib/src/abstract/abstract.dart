import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart' as framework;
abstract class AbstractBloc<Event, State> extends Bloc<Event, State>{
  framework.State pageState;

  @mustCallSuper
  AbstractBloc(this.pageState):assert(pageState != null);

  connectionExpired(){
    debugPrint("session expired");
    //TODO sesion expired push notification илгээх
    Navigator.of(pageState.context).pushNamedAndRemoveUntil("/Login", (Route<dynamic> route) => false);
  }
}