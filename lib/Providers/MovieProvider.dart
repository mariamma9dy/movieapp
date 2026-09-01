import 'package:flutter/foundation.dart';
import 'package:movieapp/Models/MovieModel.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _searchResults = [];

  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  String? _searchErrorMessage;

  // MARK: - Getters
  List<Movie> get popularMovies => _popularMovies;

  List<Movie> get topRatedMovies => _topRatedMovies;

  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  List<Movie> get searchResults => _searchResults;

  bool get isLoading => _isLoading;

  bool get isSearching => _isSearching;

  String? get errorMessage => _errorMessage;

  String? get searchErrorMessage => _searchErrorMessage;

  // MARK: - Home Movies
  void setPopularMovies(List<Movie> movies) {
    _popularMovies = movies;
    notifyListeners();
  }

  void setTopRatedMovies(List<Movie> movies) {
    _topRatedMovies = movies;
    notifyListeners();
  }

  void setNowPlayingMovies(List<Movie> movies) {
    _nowPlayingMovies = movies;
    notifyListeners();
  }

  // MARK: - Search
  void setSearchResults(List<Movie> movies) {
    _searchResults = movies;
    notifyListeners();
  }

  void clearSearchResults() {
    _searchResults = [];
    _searchErrorMessage = null;
    notifyListeners();
  }

  // MARK: - Loading
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  // MARK: - Errors
  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setSearchError(String? message) {
    _searchErrorMessage = message;
    notifyListeners();
  }
}

