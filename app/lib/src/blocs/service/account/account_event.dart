import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  AccountEvent([List props = const []]) : super(props);
}

class AccountTabSelected extends AccountEvent {
  AccountTabSelected();

  @override
  String toString() => "account tab selected.";
}
