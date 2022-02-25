import 'package:bloc_movie_proj/repository/repository.dart';
import 'package:bloc_movie_proj/models/movie_response.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingListBloc {
  MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subjcet =
      BehaviorSubject<MovieResponse>();

  getMovies() async {
    MovieResponse _response = await _repository.getPlayingMovies();
    _subjcet.sink.add(_response);
  }

  void drainStream() async {
    await _subjcet.drain();
  }

  @mustCallSuper
  void dispose() async {
    await _subjcet.drain();
    _subjcet.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subjcet;
}

final nowPlayingMoviesBloc = NowPlayingListBloc();
