import 'package:bloc_movie_proj/models/movie.dart';

class MovieResponse {
  final List<Movie> movies;
  final String error;

  const MovieResponse(this.movies, this.error);
  MovieResponse.fromJson(Map<String, dynamic> json)
      : movies = (json["results"] as List)
            .map((item) => Movie.fromJson(item))
            .toList(),
        error = "";
  MovieResponse.withError(String errorValue)
      : movies = [],
        error = errorValue;
}
