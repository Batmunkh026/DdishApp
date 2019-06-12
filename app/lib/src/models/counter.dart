class Counter {
  final String counterName;
  final String countId;
  final String counterBalance;
  final String counterMeasureUnit;
  final String counterExpireDate;

  Counter.fromJson(Map<String, dynamic> json)
      : counterName = json['counterName'],
        countId = json['countId'],
        counterBalance = json['counterBalance'],
        counterMeasureUnit = json['counterMeasureUnit'],
        counterExpireDate = json['counterExpireDate'];
}
