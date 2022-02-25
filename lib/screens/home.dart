import 'package:bloc_movie_proj/widgets/best_movies.dart';
import 'package:bloc_movie_proj/widgets/geners.dart';
import 'package:bloc_movie_proj/widgets/now_playing.dart';
import 'package:bloc_movie_proj/widgets/person_list.dart';
import 'package:flutter/material.dart';
import '../style/theme.dart' as Style;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        leading: const Icon(
          EvaIcons.menu2Outline,
        ),
        title: const Text("Discover"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(EvaIcons.searchOutline))
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: const [
          NowPlaying(),
          GenresScreen(),
          PersonsList(),
          BestMovies(),
        ],
      ),
    );
  }
}
