import 'package:ddish/src/models/result.dart';

class Movie {
  final Result result;
  final String contentId;
  final String contentNameMon;
  final String contentNameEng;
  final String contentPrice;
  final String contentDescr;
  final String contentYear;
  final String contentGenres;
  final String directors;
  final String actors;
  final String trailerUrl;
  final String posterUrl;

  Movie.fromJson(Map<String, dynamic> json)
      : result = Result.fromJson(json),
        contentId = json['contentId'],
        contentNameMon = json['contentNameMon'],
        contentNameEng = json['contentNameEng'],
        contentPrice = json['contentPrice'],
        contentDescr = json['contentDescr'],
        contentYear = json['contentYear'],
        contentGenres = json['contentGenres'],
        directors = json['directors'],
        actors = json['actors'],
        trailerUrl = json['trailerUrl'],
        posterUrl = json['posterUrl'];
}
