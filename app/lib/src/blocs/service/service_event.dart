import 'package:ddish/src/models/tab_models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  ServiceEvent([List props = const []]) : super(props);
}

class ChangeCollection extends ServiceEvent {
  @override
  String toString() => 'changing collection...';
}
class TabSelected extends ServiceEvent{
  ServiceTab selectedTab;

  TabSelected(this.selectedTab) : super([selectedTab]);

  @override
  String toString() => "selected tab : $selectedTab";
}