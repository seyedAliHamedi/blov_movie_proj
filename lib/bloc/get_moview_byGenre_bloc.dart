import 'package:rxdart/rxdart.dart';
import '../models/movie_response.dart';
import '../repository/repository.dart';
import 'package:flutter/material.dart';

class MoviesListByGenreBloc {
  final MovieRepository _repository = MovieRepository();
  BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();
  getMoviesByGenre(int id) async {
    MovieResponse _response = await _repository.getMoviesByGenre(id);
    _subject.sink.add(_response);
  }

  void drainStream() async {
    await _subject.drain();
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final moviesByGenreBloc = MoviesListByGenreBloc();
