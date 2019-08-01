import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/service/service_event.dart';
import 'package:ddish/src/blocs/service/service_state.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:flutter/material.dart';

class ServiceBloc extends AbstractBloc<ServiceEvent, ServiceState> {
  TabController tabController;

  ServiceBloc(State<StatefulWidget> pageState) : super(pageState);

  ///Үйлчилгээ цонхны default tab нь БАГЦ байна
  @override
  ServiceState get initialState => ServiceTabState(ServiceTabType.PACK);

  get servicePackTabState => ProductTabType.EXTEND;

  @override
  Stream<ServiceState> mapEventToState(ServiceEvent event) async* {
    if (event is ServiceTabSelected) {
      yield ServiceTabState(event.selectedTab);
    }
  }

  void chargeAccount() {
    assert(tabController != null);
    tabController.index = 0;
  }
}
