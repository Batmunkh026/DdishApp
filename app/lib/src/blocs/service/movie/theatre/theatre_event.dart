import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:equatable/equatable.dart';

abstract class MovieTheatreEvent extends Equatable {
  MovieTheatreEvent([List props = const []]) : super(props);
}

class MovieTheatreStarted extends MovieTheatreEvent {
  MovieTheatreStarted();

  @override
  String toString() => 'movie theatre started.';
}

class ChannelSelected extends MovieTheatreEvent {
  final VodChannel channel;
  final DateTime date;

  ChannelSelected({this.channel, this.date});

  @override
  String toString() => "channel selected";
}

class DateChanged extends MovieTheatreEvent {
  final DateTime date;
  final VodChannel channel;

  DateChanged({this.channel, this.date});

  @override
  String toString() => "channel selected";
}

class ProgramTapped extends MovieTheatreEvent {
  final Program selectedProgram;

  ProgramTapped({this.selectedProgram});

  @override
  String toString() => 'program tapped.';
}

class SearchTapped extends MovieTheatreEvent {
  final String value;

  SearchTapped({this.value});

  @override
  String toString() => 'search tapped.';
}

