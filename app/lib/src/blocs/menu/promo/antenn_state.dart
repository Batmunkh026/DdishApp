import 'package:ddish/src/models/promo.dart';
import 'package:ddish/src/models/videoManualMdl.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


abstract class AntennaState extends Equatable{}

class AntennaWidgetStarted extends AntennaState{
  AntennaWidgetStarted();
  @override
  String toString() => 'Antenna widget started.';
}
class AntennaWidgetLoading extends AntennaState{
  @override
  String toString() => 'Antenna widget loading.';
}
class AntennaWidgetLoaded extends AntennaState{
  final List<AntennMdl> manualList;
  //final List<String> manualList;
  AntennaWidgetLoaded({@required this.manualList});
  @override
  String toString() => 'Antenna widget finished.';
}

abstract class AntennaVideoState extends Equatable{}

class AntennaVideoWidgetLoading extends AntennaVideoState{
  @override
  String toString()=>'Antenna video widget loading';
}

class AntennaVideoWidgetStarted extends AntennaVideoState{
  AntennaVideoWidgetStarted();
  @override
  String toString() => 'Antenna video widget started.';
}
class AntennaVideoWidgetLoaded extends AntennaVideoState{
  final List<AntennVideoMdl> manualVideoList;
  AntennaVideoWidgetLoaded({@required this.manualVideoList});
  @override
  String toString() => 'Antenna video widget finished.';
}
class VideoManualTapped extends AntennaVideoState{
  VideoManualTapped();
  @override
  String toString() => "Video manual opened.";
}