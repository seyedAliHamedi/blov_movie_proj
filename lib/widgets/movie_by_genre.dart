import 'package:bloc_movie_proj/bloc/get_moview_byGenre_bloc.dart';
import 'package:bloc_movie_proj/models/movie.dart';
import 'package:bloc_movie_proj/models/movie_detail.dart';
import 'package:bloc_movie_proj/models/movie_response.dart';
import 'package:bloc_movie_proj/screens/details.dart';
import 'package:bloc_movie_proj/style/theme.dart' as Style;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GenreMovies extends StatefulWidget {
  GenreMovies({Key? key, required this.genreId}) : super(key: key);
  int genreId;
  @override
  _GenreMoviesState createState() => _GenreMoviesState(genreId);
}

class _GenreMoviesState extends State<GenreMovies> {
  final int genreId;
  _GenreMoviesState(this.genreId);
  @override
  void initState() {
    super.initState();
    moviesByGenreBloc.getMoviesByGenre(genreId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.error != null && snapshot.data!.error.length > 0) {
            return _buildErrorWidget(snapshot.data?.error);
          }
          return _buildHomeWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }
} // ignore: unused_element

Widget _buildLoadingWidget() {
  return const SizedBox(
    height: 300,
    child: Center(
      child: SizedBox(
        height: 25.0,
        width: 25.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 4.0,
        ),
      ),
    ),
  );
}

Widget _buildErrorWidget(String? error) {
  return SizedBox(
    height: 300,
    child: Center(child: Text("error: $error")),
  );
}

Widget _buildHomeWidget(MovieResponse? data) {
  List<Movie> movies = data!.movies;
  if (movies.isEmpty) {
    return const SizedBox(
      height: 220,
      child: Center(child: Text("NO More Movies")),
    );
  } else {
    return Container(
      height: 270.0,
      padding: const EdgeInsets.only(left: 10.0, top: 10),
      child: ListView.builder(
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailScreen(movie: movies[index])));
              },
              child: Column(
                children: [
                  movies[index].poster == null
                      ? Container(
                          width: 140,
                          height: 190,
                          decoration: const BoxDecoration(
                            color: Style.Colors.secondColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                            shape: BoxShape.rectangle,
                          ),
                          child: const Center(
                            child: Icon(
                              EvaIcons.filmOutline,
                              color: Colors.white,
                              size: 60.0,
                            ),
                          ),
                        )
                      : Container(
                          width: 140,
                          height: 190,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w200/" +
                                      movies[index].poster),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 100,
                    child: Text(
                      movies[index].title,
                      maxLines: 2,
                      style: const TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0),
                    ),
                  ),
                  const SizedBox(height: 5),
                  RatingBar(
                    itemSize: 8.0,
                    ratingWidget: RatingWidget(
                      empty: const Icon(
                        EvaIcons.star,
                        color: Style.Colors.secondColor,
                      ),
                      full: const Icon(
                        EvaIcons.star,
                        color: Style.Colors.secondColor,
                      ),
                      half: const Icon(
                        EvaIcons.star,
                        color: Style.Colors.secondColor,
                      ),
                    ),
                    initialRating: movies[index].rating / 2,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    onRatingUpdate: (rating) {
                      // ignore: avoid_print
                      print(rating);
                    },
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
