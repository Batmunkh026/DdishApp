import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


abstract class AntennaState extends Equatable{}

class AntennaWidgetStarted extends AntennaState{
  AntennaWidgetStarted();
  @override
  String toString() => 'Promo widget started.';
}
class AntennaWidgetLoading extends AntennaState{
  @override
  String toString() => 'Promo widget loading.';
}
class AntennaWidgetLoaded extends AntennaState{
  //final List<AntennMdl> manualList;
  final List<String> manualList;
  AntennaWidgetLoaded({@required this.manualList});
  @override
  String toString() => 'Antenna widget finished.';
}
