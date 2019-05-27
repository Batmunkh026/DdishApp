import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MovieApiProvider {
  Future<List<Movie>> fetchMovies() async {
    var client = http.Client();
    try {
      final response = await client.read("http://192.168.0.102:8085/movies");
      List data = json.decode(response.toString());
      List<Movie> list = new List();
      for (int i = 0; i < data.length; i++) {
        Movie movie = Movie.fromJson(data[i]);
        list.add(movie);
      }
      return list;
    } finally {
      client.close();
    }
  }
}
