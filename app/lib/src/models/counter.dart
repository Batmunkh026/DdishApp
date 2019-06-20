class Counter {
  final String counterName;
  final int countId;
  final int counterBalance;
  final String counterMeasureUnit;

  Counter.fromJson(Map<String, dynamic> json)
      : counterName = json['counterName'],
        countId = int.parse(json['countId']),
        counterBalance = int.parse(json['counterBalance']),
        counterMeasureUnit = json['counterMeasureUnit'];
}
