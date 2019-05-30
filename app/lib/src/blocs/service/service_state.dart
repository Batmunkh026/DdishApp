import 'package:equatable/equatable.dart';

abstract class ServiceState extends Equatable {
  ServiceState([List props = const []]) : super(props);
}

class ServiceInitial extends ServiceState {
  @override
  String toString() => 'service initial';
}