import 'package:ddish/src/models/tab_models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  ServiceEvent([List props = const []]) : super(props);
}

/// Үйлчилгээний төрлүүдийг солих
///Данс, Багц, Кино зэрэг табуудыг солих үед ажиллах эвент
class ServiceTabSelected extends ServiceEvent {
  ServiceTabType selectedTab;

  ServiceTabSelected(this.selectedTab) : super([selectedTab]);

  @override
  String toString() => "сонгогдсон таб ${selectedTab}";
}