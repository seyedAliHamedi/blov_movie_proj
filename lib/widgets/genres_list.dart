import 'package:bloc_movie_proj/bloc/get_moview_byGenre_bloc.dart';
import 'package:bloc_movie_proj/models/genre.dart';
import 'package:bloc_movie_proj/widgets/movie_by_genre.dart';
import 'package:flutter/material.dart';
import 'package:bloc_movie_proj/style/theme.dart' as Style;

class GenresList extends StatefulWidget {
  GenresList({Key? key, required this.genres}) : super(key: key);
  List<Genre>? genres;
  @override
  _GenresListState createState() => _GenresListState(genres!);
}

class _GenresListState extends State<GenresList>
    with SingleTickerProviderStateMixin {
  final List<Genre> genres;
  _GenresListState(this.genres);
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: genres.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        moviesByGenreBloc.drainStream();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320.0,
      color: Style.Colors.mainColor,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: Style.Colors.mainColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: Style.Colors.mainColor,
              bottom: TabBar(
                isScrollable: true,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                indicatorColor: Style.Colors.secondColor,
                indicatorWeight: 3,
                unselectedLabelColor: Style.Colors.titleColor,
                tabs: genres
                    .map(
                      (e) => Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(e.name.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold)),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: genres.map((Genre genre) {
                return GenreMovies(genreId: genre.id);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
