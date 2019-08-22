class Counter {
  final String counterName;
  final int countId;
  final String counterBalance;
  final String counterMeasureUnit;

  Counter.fromJson(Map<String, dynamic> json)
      : counterName = json['counterName'],
        countId = int.parse(json['countId']),
        counterBalance = json['counterBalance'],
        counterMeasureUnit = json['counterMeasureUnit'];
}
