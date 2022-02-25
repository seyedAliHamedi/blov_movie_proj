import 'package:bloc_movie_proj/bloc/get_movie_similar_bloc.dart';
import 'package:bloc_movie_proj/models/movie.dart';
import 'package:bloc_movie_proj/models/movie_response.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../bloc/get_casts_bloc.dart';
import '../models/cast.dart';
import '../models/cast_response.dart';
import '../screens/details.dart';
import '../style/theme.dart' as Style;

class SimilarMovies extends StatefulWidget {
  final int id;
  // ignore: use_key_in_widget_constructors
  const SimilarMovies({required this.id});
  @override
  _SimilarMoviesState createState() => _SimilarMoviesState(id);
}

class _SimilarMoviesState extends State<SimilarMovies> {
  final int id;
  _SimilarMoviesState(this.id);
  @override
  void initState() {
    super.initState();
    similarMoviesBloc.getSimilarMovie(id);
  }

  @override
  void dispose() {
    similarMoviesBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 5.0),
          child: Text(
            "SIMILAR MOVIES",
            style: TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        StreamBuilder<MovieResponse>(
          stream: similarMoviesBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error != null &&
                  snapshot.data!.error.length > 0) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildCastWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else {
              return _buildLoadingWidget();
            }
          },
        )
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 4.0,
          ),
        )
      ],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildCastWidget(MovieResponse? data) {
    List<Movie>? movies = data?.movies;
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: movies!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                children: [
                  Hero(
                    tag: movies[index].id,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movie: movies[index])));
                      },
                      child: Container(
                          width: 120.0,
                          height: 180.0,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200/" +
                                        movies[index].poster)),
                          )),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movies[index].title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        movies[index].rating.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      RatingBar(
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
                        itemSize: 8.0,
                        initialRating: movies[index].rating / 2,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
