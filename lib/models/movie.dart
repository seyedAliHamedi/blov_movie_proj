class Movie {
  final int id;
  final num popularity;
  final num rating;
  final String title;
  final String backPoster;
  final String poster;
  final String overview;

  const Movie(this.id, this.popularity, this.rating, this.title,
      this.backPoster, this.poster, this.overview);

  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        popularity = json["popularity"],
        backPoster = json["backdrop_path"] ?? "",
        poster = json["poster_path"],
        overview = json["overview"],
        rating = json["vote_average"].toDouble();
}
