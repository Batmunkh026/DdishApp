import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_event.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_state.dart';
import 'package:ddish/src/models/promo.dart';
import 'package:ddish/src/repositiories/promo_repository.dart';

class AntennaBloc extends AbstractBloc<AntennaEvent, AntennaState>{
  final AntennRepository repository;
  AntennaBloc(pageState, {this.repository}) : super(pageState);

  @override
  AntennaState get initialState => AntennaWidgetStarted();

  @override
  Stream<AntennaState> mapEventToState(AntennaEvent event) async*{
    if(event is AntennaEventStarted){
      yield AntennaWidgetLoading();
      List<AntennMdl> manuals = await repository.fetchAntenna();
//      List<String> manualItems = <String>[
//        'assets/antenna/app_stb_01.jpg',
//        'assets/antenna/app_stb_02.jpg',
//        'assets/antenna/app_stb_03.jpg',
//      ];
      yield AntennaWidgetLoaded(manualList: manuals);
    }

  }
}

class AntennaVideoBloc extends Bloc <AntennaVideoEvent, AntennaVideoState>{
  final AntennVideoRepository repository;
  AntennaVideoBloc({this.repository});

  @override
  AntennaVideoState get initialState =>AntennaVideoWidgetStarted();
  @override
  Stream<AntennaVideoState> mapEventToState(AntennaVideoEvent event) async*{
    if(event is AntennaVideoEventStarted){
      yield AntennaVideoWidgetLoading();
//      List<VideoManual> manualItems = <VideoManual>[
//        VideoManual(videoId: '05G8OWl8Elc', videoName: 'Aнтенн тохируулах заавар 1'),
//        VideoManual(videoId: 'lj227NG1_Bs', videoName: 'Aнтенн тохируулах заавар 2'),
//      ];
      List<AntennVideoMdl> manualItems = await repository.fetchAntennaVideo();
      yield AntennaVideoWidgetLoaded(manualVideoList: manualItems);
    }
  }
}