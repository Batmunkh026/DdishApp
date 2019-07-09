import 'package:ddish/src/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserInformationState extends Equatable {
  UserInformationState([List props = const []]) : super(props);
}

class UserInformationInitial extends UserInformationState {
  @override
  String toString() => 'LoginInitial';
}

class UserInformationLoaded extends UserInformationState {
  final User user;
  UserInformationLoaded({this.user});
  @override
  String toString() => 'LoginLoading';
}
