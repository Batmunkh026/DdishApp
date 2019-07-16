import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_event.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_state.dart';
import 'package:ddish/src/repositiories/promo_repository.dart';

class AntennaBloc extends Bloc<AntennaEvent, AntennaState>{
  final AntennRepository repository;
  AntennaBloc({this.repository});

  @override
  AntennaState get initialState => AntennaWidgetStarted();

  @override
  Stream<AntennaState> mapEventToState(AntennaEvent event) async*{
    if(event is AntennaEventStarted){
      yield AntennaWidgetLoading();
      //List<AntennMdl> manuals = await repository.fetchAntenna();
      List<String> manualItems = <String>[
        'assets/antenna/app_stb_01.jpg',
        'assets/antenna/app_stb_02.jpg',
        'assets/antenna/app_stb_03.jpg',
      ];
      yield AntennaWidgetLoaded(manualList: manualItems);
    }

  }
}