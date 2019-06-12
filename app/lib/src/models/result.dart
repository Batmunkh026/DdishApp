class Result {
  final bool isSuccess;
  final String resultCode;
  final String resultMessage;

  Result({this.isSuccess, this.resultCode, this.resultMessage});

  Result.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'],
        resultCode = json['resultCode'],
        resultMessage = json['resultMessage'];
}
