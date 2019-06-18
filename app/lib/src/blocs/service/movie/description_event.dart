import 'package:ddish/src/models/program.dart';
import 'package:equatable/equatable.dart';

abstract class DescriptionEvent extends Equatable {}

class ProgramDescriptionStarted extends DescriptionEvent {
  Program selectedProgram;
  ProgramDescriptionStarted({this.selectedProgram});
  @override
  String toString() => 'program ';
}

class RentTapped extends DescriptionEvent {
  final Program rentProgram;

  RentTapped({this.rentProgram});

  @override
  String toString() => 'rent tapped.';
}