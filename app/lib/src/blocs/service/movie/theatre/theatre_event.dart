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

class ScrollReachedMax extends MovieTheatreEvent {
  final String value;
  final int page;

  ScrollReachedMax({this.value, this.page});

  @override
  String toString() => 'Fetch';
}

class ReturnTapped extends MovieTheatreEvent {
  final bool search;
  final List programList;

  ReturnTapped({this.search, this.programList});

  @override
  String toString() => 'return tapped.';
}
