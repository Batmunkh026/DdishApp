import 'package:ddish/src/models/tab_models.dart';
import 'package:equatable/equatable.dart';

abstract class AccountState extends Equatable {
  AccountState([List props = const []]) : super(props);
}

class AccountBalanceStarted extends AccountState{
  AccountBalanceStarted();
  @override
  String toString() => 'account balance started.';
}

class AccountBalanceLoading extends AccountState{
  AccountBalanceLoading();
  @override
  String toString() => 'account balance loading.';
}

class AccountBalanceLoaded extends AccountState{
  AccountBalanceLoaded();
  @override
  String toString() => 'account balance loaded.';
}