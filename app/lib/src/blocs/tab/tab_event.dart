import 'package:ddish/src/models/tab_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TabEvent extends Equatable {
  TabEvent([List props = const []]) : super(props);
}

class UpdateTab extends TabEvent {
  final TabState tab;

  UpdateTab(this.tab) : super([tab]);

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}
