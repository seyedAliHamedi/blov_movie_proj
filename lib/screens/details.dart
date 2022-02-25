import 'package:bloc_movie_proj/bloc/get_movie_detail_bloc.dart';
import 'package:bloc_movie_proj/bloc/get_movie_similar_bloc.dart';
import 'package:bloc_movie_proj/bloc/get_movie_videos_bloc.dart';
import 'package:bloc_movie_proj/models/movie.dart';
import 'package:bloc_movie_proj/models/movie_response.dart';
import 'package:bloc_movie_proj/models/video.dart';
import 'package:bloc_movie_proj/models/video_response.dart';
import 'package:bloc_movie_proj/screens/video_player.dart';
import 'package:bloc_movie_proj/style/theme.dart' as Style;
import 'package:bloc_movie_proj/widgets/casts.dart';
import 'package:bloc_movie_proj/widgets/movie_info.dart';
import 'package:bloc_movie_proj/widgets/similar_movies.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  MovieDetailScreen({Key? key, required this.movie}) : super(key: key);
  Movie movie;
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Movie movie;
  _MovieDetailScreenState(this.movie);
  @override
  void initState() {
    // TODO: implement initState
    movieVideosBloc.getMovieVideo(movie.id);
    super.initState();
  }

  void dispose() {
    super.dispose();
    movieVideosBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        movie.title.length > 40
                            ? movie.title.substring(0, 37) + "...."
                            : movie.title,
                        style: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.normal),
                      ),
                      background: Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/" +
                                      movie.backPoster),
                            ),
                          ),
                          child: Container(color: Colors.black54),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: const [
                                0.1,
                                0.9
                              ],
                                  colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0.0)
                              ])),
                        )
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  movie.rating.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                RatingBar(
                                  itemSize: 10.0,
                                  initialRating: movie.rating / 2,
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
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 20.0),
                            child: Text(
                              "OVERVIEW",
                              style: TextStyle(
                                  color: Style.Colors.titleColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              movie.overview,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: MovieInfo(
                              id: movie.id,
                            ),
                          ),
                          Casts(
                            id: movie.id,
                          ),
                          SimilarMovies(
                            id: movie.id,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              StreamBuilder<VideoResponse>(
                stream: movieVideosBloc.subject.stream,
                builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.error != null &&
                        snapshot.data!.error.length > 0) {
                      return _buildErrorWidget(snapshot.data!.error);
                    }
                    return _buildHomeWidget(snapshot.data);
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error.toString());
                  } else {
                    return _buildLoadingWidget();
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
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

  Widget _buildHomeWidget(VideoResponse? data) {
    List<Video>? videos = data?.videos;
    return Positioned(
      top: 212,
      right: 30,
      child: FloatingActionButton(
        backgroundColor: Style.Colors.secondColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                controller: YoutubePlayerController(
                  initialVideoId: videos![0].key,
                  flags: const YoutubePlayerFlags(
                    autoPlay: true,
                    mute: true,
                  ),
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
