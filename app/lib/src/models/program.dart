class Program {
  final String productId;
  final String smsCode;
  final String contentId;
  final String contentNameMon;
  final String contentNameEng;
  final String contentGenres;
  final String contentPrice;
  final String beginDate;
  final String endDate;
  final String posterUrl;

  Program.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        smsCode = json['smsCode'],
        contentId = json['contentId'],
        contentNameMon = json['contentNameMon'],
        contentNameEng = json['contentNameEng'],
        contentPrice = json['contentPrice'],
        beginDate = json['beginDate'],
        endDate = json['endDate'],
        posterUrl = json['posterUrl'],
        contentGenres = json['contentGenres'];
}

class ProgramList {
  final List<Program> programs;

  ProgramList({this.programs});

  factory ProgramList.fromJson(List<dynamic> parsedJson) {
    List<Program> activeProducts =
        parsedJson.map((i) => Program.fromJson(i)).toList();
    return ProgramList(
      programs: activeProducts,
    );
  }
}
