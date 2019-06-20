import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class MovieLibraryEvent extends Equatable {
  MovieLibraryEvent([List props = const []]) : super(props);
}

class ContentLibraryStarted extends MovieLibraryEvent {
  ContentLibraryStarted();

  @override
  String toString() => "content library started.";
}

class ContentOrderClicked extends MovieLibraryEvent {
  final int contentId;

  ContentOrderClicked({@required this.contentId});

  @override
  String toString() => "content order clicked. id: $contentId";
}
