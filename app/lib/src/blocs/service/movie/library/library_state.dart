import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/result.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class MovieLibraryState extends Equatable {}

class ContentListLoading extends MovieLibraryState {
  @override
  String toString() => 'movie list loading.';
}

class ContentListLoaded extends MovieLibraryState {
  final List<String> posterUrls;

  ContentListLoaded({@required this.posterUrls});

  @override
  String toString() => 'movie list loaded.';
}

class ContentOrderRequestProcessing extends MovieLibraryState {
  ContentOrderRequestProcessing();

  @override
  String toString() => "content order request processing";
}

class ContentOrderRequestFinished extends MovieLibraryState {
  final Result result;

  ContentOrderRequestFinished({this.result});

  @override
  String toString() => "content order request finished";
}
