import 'package:ddish/src/models/promo.dart';
import 'package:ddish/src/models/videoManualMdl.dart';
import 'package:ddish/src/repositiories/promo_repository.dart';
import 'package:ddish/src/templates/service/movie/description/dialog_close.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_bloc.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_event.dart';
import 'package:ddish/src/blocs/menu/promo/antenn_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';


class AntennaVideoWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AntennaVideoWidgetState();
}

class AntennaVideoWidgetState extends State<AntennaVideoWidget>{
  AntennaVideoBloc _bloc;
  AntennVideoRepository _repository;
  List<AntennVideoMdl> manuals;
  VideoManual selectedManual;

  @override
  void initState(){
    manuals = List<AntennVideoMdl>();
    _repository = AntennVideoRepository();
    _bloc = AntennaVideoBloc(repository: _repository);
    super.initState();
  }
  @override
  void dispose(){
    _bloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<AntennaVideoEvent, AntennaVideoState>(
      bloc: _bloc,
      builder: (BuildContext context, AntennaVideoState state){
        if(state is AntennaVideoWidgetLoading){
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(state is AntennaVideoWidgetStarted){
          _bloc.dispatch(AntennaVideoEventStarted());
        }
        if(state is AntennaVideoWidgetLoaded){
          manuals = state.manualVideoList;
          return manuals !=null ?
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: ListView.builder(
                itemCount: manuals.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: GestureDetector(
                      child: Container(
                        //padding: const EdgeInsets.fromLTRB(150.0, 150.0, 0.0, 0.0),
                        child: Center(
                          child: Text(
                            manuals[index].videoName,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: const Color(0xFFe4f0ff),
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                              fontFamily: 'Montserrat',
                            ),
                          )
                        )
                      ),
                      onTap: ()=> showTrailer(manuals[index]),
                    ),
                  );
                },
              ),
            ),
          ):Container();
        }
        return Container(
          child: Text(
            'Calling Next Form',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
  onVideoManualTap(VideoManual manual){
    selectedManual = manual;
    _bloc.dispatch(ManualTapped());
  }
  showTrailer(AntennVideoMdl vmanual) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Stack(
                children: <Widget>[
                  SimpleDialog(
                    contentPadding: const EdgeInsets.all(0.0),
                    children: <Widget>[
                      Align(
                        child: YoutubePlayer(
                          context: context,
                          videoId: vmanual.videoId,
                          autoPlay: false,
                          showVideoProgressIndicator: true,
                          videoProgressIndicatorColor: Colors.red,
                        ),
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: DialogCloseButton(
                          onTap: () => Navigator.pop(context)),
                    ),
                    alignment: Alignment.bottomCenter,
                  )
                ],
              ));
        });
  }
}