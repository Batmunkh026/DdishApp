import 'package:ddish/src/models/counter.dart';

class CounterList {
  List<Counter> counterList;

  CounterList({this.counterList});

  factory CounterList.fromJson(List<dynamic> parsedJson) {
    List activeCounters = parsedJson.map((counter) => Counter.fromJson(counter)).toList();
    return CounterList(
      counterList: activeCounters,
    );
  }
}