import 'package:ddish/src/blocs/mixin/bloc_mixin.dart';
import 'package:equatable/equatable.dart';

abstract class UserInformationEvent extends Equatable {
  UserInformationEvent([List props = const []]) : super(props);
}

class UserInformationStarted extends UserInformationEvent with NetworkAccessRequired {
  @override
  String toString() => 'user information started.';
}