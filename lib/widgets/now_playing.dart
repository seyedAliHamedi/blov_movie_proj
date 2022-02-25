import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bloc_movie_proj/bloc/get_now_playing_bloc.dart';
import 'package:bloc_movie_proj/models/movie.dart';
import 'package:bloc_movie_proj/models/movie_response.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:bloc_movie_proj/style/theme.dart' as Style;

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

PageController pageController =
    PageController(viewportFraction: 1, keepPage: true);

class _NowPlayingState extends State<NowPlaying> {
  @override
  void initState() {
    nowPlayingMoviesBloc.getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingMoviesBloc.subject.stream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.error != null && snapshot.data!.error.isNotEmpty) {
            return _buildErrorWidget(snapshot.data?.error);
          } else {
            return _buildHomeWidget(snapshot.data);
          }
        } else if (snapshot.hasData) {
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          return _buildLoadingWidget();
        }
      }),
    );
  }
}

// ignore: unused_element
Widget _buildLoadingWidget() {
  return const SizedBox(
    height: 220,
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
    height: 220,
    child: Center(child: Text("error: $error")),
  );
}

Widget _buildHomeWidget(MovieResponse? data) {
  List<Movie> movies = data!.movies;
  if (movies.isEmpty) {
    return const SizedBox(
      width: double.infinity,
      height: 220,
      child: Center(child: Text("There is no movies")),
    );
  }
  return SizedBox(
    height: 220.0,
    child: PageIndicatorContainer(
      length: 5,
      align: IndicatorAlign.bottom,
      indicatorSpace: 8.0,
      indicatorColor: Style.Colors.titleColor,
      indicatorSelectorColor: Style.Colors.secondColor,
      shape: IndicatorShape.circle(size: 5.0),
      padding: const EdgeInsets.all(5.0),
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: ((context, index) {
          return Stack(
            children: [
              Hero(
                tag: movies[index].title,
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/original/" +
                              movies[index].backPoster),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Style.Colors.mainColor.withOpacity(1.0),
                      Style.Colors.mainColor.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.9],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              const Positioned(
                bottom: 0.0,
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Icon(
                  FontAwesomeIcons.playCircle,
                  color: Style.Colors.secondColor,
                  size: 40.0,
                ),
              ),
              Positioned(
                bottom: 25,
                left: 25,
                child: Text(
                  movies[index].title,
                  style: const TextStyle(
                      height: 1.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              )
            ],
          );
        }),
      ),
    ),
  );
}
