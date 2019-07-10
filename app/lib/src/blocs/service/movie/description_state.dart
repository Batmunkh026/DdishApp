import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/result.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class DescriptionState extends Equatable {}

class ProgramDescriptionInitial extends DescriptionState {
  ProgramDescriptionInitial();
  @override
  String toString() => "program description initial.";
}

class ProgramDetailsLoading extends DescriptionState {
  ProgramDetailsLoading();
  @override
  String toString() => 'program details loading.';
}


class ProgramDetailsLoaded extends DescriptionState {
  final Movie content;

  ProgramDetailsLoaded({@required this.content});
  @override
  String toString() => 'program details loaded.';
}

class RentRequestProcessing extends DescriptionState {
  RentRequestProcessing();
  @override
  String toString() => "rent request processing.";
}

class RentRequestFinished extends DescriptionState {
  final Result result;
  bool isNotOpened = true;

  RentRequestFinished({this.result});

  @override
  String toString() => "rent request finished.";

}