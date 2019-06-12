import 'package:ddish/src/models/vod_channel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ddish/src/models/movie.dart';

abstract class MovieTheatreEvent extends Equatable{
  MovieTheatreEvent([List props = const []]) : super(props);
}

class MovieTheatreStarted extends MovieTheatreEvent {
  MovieTheatreStarted();
  @override
  String toString() => 'movie theatre started.';
}

class ChannelSelected extends MovieTheatreEvent {
  final VodChannel channel;
  ChannelSelected({this.channel});
  @override
  String toString() => "channel selected";
}
