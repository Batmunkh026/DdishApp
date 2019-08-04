import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart' as framework;
import 'package:logging/logging.dart';

abstract class AbstractBloc<Event, State> extends Bloc<Event, State> {
  final Logger log = new Logger('AbstractBloc');
  framework.State pageState;

  @mustCallSuper
  AbstractBloc(this.pageState) : assert(pageState != null);

  connectionExpired(message) {
    log.warning(message);
    //TODO sesion expired push notification илгээх
    try {
      Navigator.of(pageState.context)
          .pushNamedAndRemoveUntil("/Login", (_) => false);
    } catch (e) {
      log.warning(e);
    }
  }
}