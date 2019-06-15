import 'package:ddish/src/models/counter.dart';
import 'package:equatable/equatable.dart';

abstract class AccountState extends Equatable {
  AccountState([List props = const []]) : super(props);
}

class AccountBalanceStarted extends AccountState {
  AccountBalanceStarted();

  @override
  String toString() => 'account balance started.';
}

class AccountBalanceLoaded extends AccountState {
  final Counter mainCounter;

  AccountBalanceLoaded({this.mainCounter});

  @override
  String toString() => 'account balance loaded.';
}
