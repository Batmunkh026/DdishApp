import 'package:ddish/src/models/result.dart';

class Movie {
  final Result result;
  final int contentId;
  final String contentNameMon;
  final String contentNameEng;
  final int contentPrice;
  final String contentDescr;
//  final int contentYear;
  final String contentGenres;
  final String directors;
  final String actors;
  final String trailerUrl;
  final String posterUrl;

  Movie.fromJson(Map<String, dynamic> json)
      : result = Result.fromJson(json),
        contentId = int.parse(json['contentId']),
        contentNameMon = json['contentNameMon'],
        contentNameEng = json['contentNameEng'],
        contentPrice = int.parse(json['contentPrice']),
        contentDescr = json['contentDescr'],
//        contentYear = int.parse(json['contentYear']),
        contentGenres = json['contentGenres'],
        directors = json['directors'],
        actors = json['actors'],
        trailerUrl = json['trailerUrl'],
        posterUrl = json['posterUrl'];
}
