import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

///Багцын төлөв
abstract class MovieTheatreState extends Equatable {
  MovieTheatreState([List props = const []]) : super(props);
}

class TheatreStateInitial extends MovieTheatreState {
  TheatreStateInitial();
  @override
  String toString() => "theatre state initial.";
}

class ChannelListLoading extends MovieTheatreState {
  ChannelListLoading();
  @override
  String toString() => "channel list loading.";
}

class ChannelListLoaded extends MovieTheatreState {
  final List<VodChannel> channelList;
  ChannelListLoaded({this.channelList});
  @override
  String toString() => "channel list loaded.";
}


class ProgramListLoading extends MovieTheatreState {
  final VodChannel channel;

  ProgramListLoading({this.channel});

  @override
  String toString() => 'program list loading.';
}

class ProgramListLoaded extends MovieTheatreState {
  final List<Program> programList;

  ProgramListLoaded({@required this.programList});

  @override
  String toString() => 'program list loaded.';
}

class ProgramDetailsLoading extends MovieTheatreState {
  ProgramDetailsLoading();
  @override
  String toString() => 'program details loading.';
}


class ProgramDetailsLoaded extends MovieTheatreState {
  final Movie content;

  ProgramDetailsLoaded({@required this.content});
  @override
  String toString() => 'program details loaded.';
}

class SearchProgramLoading extends MovieTheatreState {
  SearchProgramLoading();
  @override
  String toString() => "search program loading.";
}

class SearchResultOpened extends MovieTheatreState {
  SearchResultOpened();
  @override
  String toString() => 'search result opened.';
}