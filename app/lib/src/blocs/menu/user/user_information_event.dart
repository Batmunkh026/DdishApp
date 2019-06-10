import 'package:equatable/equatable.dart';

abstract class UserInformationEvent extends Equatable {
  UserInformationEvent([List props = const []]) : super(props);
}

class UserInformationStarted extends UserInformationEvent {
  @override
  String toString() => 'user information started.';
}