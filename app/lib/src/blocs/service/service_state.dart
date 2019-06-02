import 'package:ddish/src/models/tab_models.dart';
import 'package:equatable/equatable.dart';

abstract class ServiceState extends Equatable {
  ServiceState([List props = const []]) : super(props);
}

class ServiceTabState extends ServiceState{
  ServiceTabType selectedTab;
  ServiceTabState(this.selectedTab) : super([selectedTab]);
}