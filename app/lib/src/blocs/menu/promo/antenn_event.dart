import 'package:equatable/equatable.dart';


abstract class AntennaEvent extends Equatable {
  AntennaEvent([List props = const []]) : super(props);
}

class AntennaEventStarted extends AntennaEvent {
  AntennaEventStarted();
  @override
  String toString() => "Antenna event started.";
}

abstract class AntennaVideoEvent extends Equatable{
  AntennaVideoEvent ([List props = const[]]):super(props);
}
class AntennaVideoEventStarted extends AntennaVideoEvent{
  AntennaVideoEventStarted();
  @override
  String toString() => 'Antenna video event started.';
}
class ManualTapped extends AntennaVideoEvent{
  ManualTapped();
  @override
  String toString() => "Antenna video event tapped.";
}