import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

abstract class AbstractBloc<Event, S> extends Bloc<Event, S> {
  final Logger log = new Logger('AbstractBloc');
  State pageState;

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