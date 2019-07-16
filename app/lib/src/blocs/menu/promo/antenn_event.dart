import 'package:equatable/equatable.dart';


abstract class AntennaEvent extends Equatable {
  AntennaEvent([List props = const []]) : super(props);
}

class AntennaEventStarted extends AntennaEvent {
  AntennaEventStarted();
  @override
  String toString() => "Antenna event started.";
}