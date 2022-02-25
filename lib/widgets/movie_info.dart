import 'package:bloc_movie_proj/bloc/get_movie_detail_bloc.dart';
import 'package:bloc_movie_proj/models/movie_detail.dart';
import 'package:bloc_movie_proj/models/movie_detail_response.dart';
import 'package:flutter/material.dart';
import 'package:bloc_movie_proj/style/theme.dart' as Style;

class MovieInfo extends StatefulWidget {
  const MovieInfo({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _MovieInfoState createState() => _MovieInfoState(id);
}

class _MovieInfoState extends State<MovieInfo> {
  int id;
  _MovieInfoState(this.id);
  @override
  void initState() {
    movieDetailBloc.getMovieDetail(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
      stream: movieDetailBloc.subject.stream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.error != null && snapshot.data!.error.isNotEmpty) {
            print(snapshot.data!.movieDetail.genres);
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

Widget _buildHomeWidget(MovieDetailResponse? data) {
  MovieDetail? details = data?.movieDetail;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Text(
                "BUDGET",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 7),
              Text(
                details!.budget.toString(),
                style: const TextStyle(
                    color: Style.Colors.secondColor, fontSize: 13),
              )
            ],
          ),
          Column(
            children: [
              const Text(
                "DURATION",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 7),
              Text(
                details.runtime.toString(),
                style: const TextStyle(
                    color: Style.Colors.secondColor, fontSize: 13),
              )
            ],
          ),
          Column(
            children: [
              const Text(
                "RELEASE-DATE",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 7),
              Text(
                details.releaseDate.toString(),
                style: const TextStyle(
                    color: Style.Colors.secondColor, fontSize: 13),
              )
            ],
          ),
        ],
      ),
      const SizedBox(height: 20),
      const Text(
        "GENRES",
        style: TextStyle(color: Colors.white, fontSize: 13),
      ),
      Container(
        height: 38.0,
        padding: const EdgeInsets.only(right: 10.0, top: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: details.genres.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 10.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(width: 1.0, color: Colors.white)),
              child: Text(
                details.genres[index].name,
                maxLines: 2,
                style: const TextStyle(
                    height: 1.4,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 9.0),
              ),
            );
          },
        ),
      )
    ],
  );
}
