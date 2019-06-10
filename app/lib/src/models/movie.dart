class Movie {
  String title;
  DateTime startDateTime;
  List genres;
  String overview;
  int rental;
  String coverMiniUrl;
  String coverUrl;
  List imageUrls;
  String trailerUrl;

  Movie.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        startDateTime = DateTime.parse(json['startDateTime']),
        genres = json['genres'],
        overview = json['overview'],
        rental = json['rental'],
        coverMiniUrl = json['coverMiniUrl'],
        coverUrl = json['coverUrl'],
        imageUrls = json['imageUrls'],
        trailerUrl = json['trailerUrl'];
}
