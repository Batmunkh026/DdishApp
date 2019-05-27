class Movie {
  String title;
  double rating;
  int duration;
  DateTime startDateTime;
  List genres;
  String overview;
  int rental;
  String posterUrl;

  Movie.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        rating = json['rating'],
        duration = json['duration'],
        startDateTime = DateTime.parse(json['startDateTime']),
        genres = json['genres'],
        overview = json['overview'],
        rental = json['rental'],
        posterUrl = json['posterUrl'];
}
