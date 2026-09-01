import 'package:flutter/foundation.dart';
import 'package:movieapp/Models/MovieModel.dart';

class MovieProvider extends ChangeNotifier {
  //MARK:- Lists
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];

  bool _isLoading = false;

  String? _errorMessage;

  //MARK:- Getters

  List<Movie> get popularMovies => _popularMovies;

  List<Movie> get topRatedMovies => _topRatedMovies;

  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  //MARK:- Setters

  // Set Popular Movies

  void setPopularMovies(List<Movie> movies) {
    _popularMovies = movies;
    notifyListeners();
  }

  // Set Top Rated Movies

  void setTopRatedMovies(List<Movie> movies) {
    _topRatedMovies = movies;
    notifyListeners();
  }

  // Set Now Playing Movies

  void setNowPlayingMovies(List<Movie> movies) {
    _nowPlayingMovies = movies;
    notifyListeners();
  }

  // Loading

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Error

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}

