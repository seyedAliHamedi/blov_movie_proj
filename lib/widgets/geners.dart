import 'package:bloc_movie_proj/bloc/get_genres_bloc.dart';
import 'package:bloc_movie_proj/models/genre.dart';
import 'package:bloc_movie_proj/models/genre_response.dart';
import 'package:flutter/material.dart';

import 'genres_list.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  @override
  void initState() {
    genresBloc.getGenres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
      stream: genresBloc.subject.stream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.error != null && snapshot.data!.error.length > 0) {
            print("222222fadafdafdsfds");
            return _buildErrorWidget(snapshot.data?.error);
          }
          return _buildHomeWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          return _buildLoadingWidget();
        }
      }),
    );
  }
}

Widget _buildErrorWidget(String? error) {
  return SizedBox(
    width: double.infinity,
    height: 200,
    child: Center(child: Text("Error : $error")),
  );
}

Widget _buildLoadingWidget() {
  return const SizedBox(
    width: double.infinity,
    height: 200,
    child: Center(
      child: CircularProgressIndicator(
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    ),
  );
}

Widget _buildHomeWidget(GenreResponse? data) {
  List<Genre>? _genres = data?.genres;
  if (_genres?.length == 0) {
    return const SizedBox(
      width: double.infinity,
      height: 200,
      child: Center(child: Text("No More Movies!!!")),
    );
  } else {
    return GenresList(genres: _genres);
  }
}
