import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/service_event.dart';
import 'package:ddish/src/blocs/service/service_state.dart';
import 'package:ddish/src/models/tab_models.dart';

import '../base_bloc_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ///Үйлчилгээ цонхны default tab нь БАГЦ байна
  @override
  ServiceState get initialState => ServiceTabState(ServiceTabType.PACK);

  get servicePackTabState => PackTabType.EXTEND;

  @override
  Stream<ServiceState> mapEventToState(ServiceEvent event) async* {
    if (event is ServiceTabSelected) {
      yield ServiceTabSelected(event.selectedTab) as ServiceState;
    }
  }
}
