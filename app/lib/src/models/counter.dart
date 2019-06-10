class Counter {
  final String counterName;
  final int countId;
  final int countBalance;
  final String counterMeasureUnit;
  final DateTime counterExpireDate;

  Counter.fromJson(Map<String, dynamic> json)
      : counterName = json['counterName'],
        countId = json['countId'],
        countBalance = json['countBalance'],
        counterMeasureUnit = json['counterMeasureUnit'],
        counterExpireDate = DateTime.parse(json['counterExpireDate']);
}
