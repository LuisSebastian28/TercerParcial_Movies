import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Movies.dart';

class MovieRepository {
  final String apiKey = 'fa3e844ce31744388e07fa47c7c5d8c3';
  final String baseUrl = 'https://api.themoviedb.org/3/discover/movie';

  Future<List<Movie>> fetchMovies() async {
    final response = await http
        .get(Uri.parse('$baseUrl?sort_by=popularity.desc&api_key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Movie> movies = (data['results'] as List)
          .map((movieData) => Movie.fromJson(movieData))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
