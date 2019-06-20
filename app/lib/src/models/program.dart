class Program {
  final int productId;
  final int smsCode;
  final int contentId;
  final String contentNameMon;
  final String contentNameEng;
  final String contentGenres;
  final int contentPrice;
  final DateTime beginDate;
  final DateTime endDate;
  final String posterUrl;

  Program.fromJson(Map<String, dynamic> json)
      : productId = int.parse(json['productId']),
        smsCode = int.parse(json['smsCode']),
        contentId = int.parse(json['contentId']),
        contentNameMon = json['contentNameMon'],
        contentNameEng = json['contentNameEng'],
        contentPrice = int.parse(json['contentPrice']),
        beginDate = DateTime.parse(json['beginDate']),
        endDate = DateTime.parse(json['endDate']),
        posterUrl = json['posterUrl'],
        contentGenres = json['contentGenres'];
}
