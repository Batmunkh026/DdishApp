import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/service_event.dart';
import 'package:ddish/src/blocs/service/service_state.dart';
import 'package:ddish/src/models/tab_models.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  @override
  ServiceState get initialState => ServiceInitial();

  @override
  Stream<ServiceState> mapEventToState(ServiceEvent event) async* {
    if (event is ServiceInitial)
      yield ServiceInitial();
    else if (event is TabSelected) {
      if (event.selectedTab == ServiceTab.ACCOUNT) {
        //TODO Данс сонгосон үед хийх зүйл бичих
      } else if (event.selectedTab == ServiceTab.COLLECTION) {
        //TODO Багц сонгосон үед хийх зүйл бичих
      } else if (event.selectedTab == ServiceTab.MOVIE) {
        //TODO Кино сонгосон үед хийх зүйл бичих
      }else
        throw UnsupportedError("тодорхойгүй төлөв: ${event.selectedTab}");
    }
  }
}
