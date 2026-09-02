import 'package:flutter/foundation.dart';
import 'package:movieapp/Models/MovieModel.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _searchResults = [];

  List<Movie> _favorites = [];
  List<Movie> _myList = [];
  List<Movie> _recentlyViewed = [];

  bool _isLoading = false;
  bool _isSearching = false;

  String? _errorMessage;
  String? _searchErrorMessage;

  // MARK: - Getters

  List<Movie> get popularMovies => _popularMovies;

  List<Movie> get topRatedMovies => _topRatedMovies;

  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  List<Movie> get searchResults => _searchResults;

  List<Movie> get favorites => _favorites;

  List<Movie> get myList => _myList;

  List<Movie> get recentlyViewed => _recentlyViewed;

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

  // MARK: - Favorites

  void setFavorites(List<Movie> movies) {
    _favorites = movies;
    notifyListeners();
  }

  void addFavorite(Movie movie) {
    // if movie not in favs
    if (!_favorites.any((item) => item.id == movie.id)) {
      _favorites.add(movie);
      notifyListeners();
    }
  }

  void removeFavorite(int movieId) {
    _favorites.removeWhere((movie) => movie.id == movieId);
    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return _favorites.any((movie) => movie.id == movieId);
  }

  // MARK: - My List

  void setMyList(List<Movie> movies) {
    _myList = movies;
    notifyListeners();
  }

  void addMovieToList(Movie movie) {
    if (!_myList.any((item) => item.id == movie.id)) {
      _myList.add(movie);
      notifyListeners();
    }
  }

  void removeMovieFromList(int movieId) {
    _myList.removeWhere((movie) => movie.id == movieId);
    notifyListeners();
  }

  bool isInMyList(int movieId) {
    return _myList.any((movie) => movie.id == movieId);
  }

  // MARK: - Recently Viewed

  void setRecentlyViewed(List<Movie> movies) {
    _recentlyViewed = movies;
    notifyListeners();
  }

  void addRecentlyViewed(Movie movie) {
    _recentlyViewed.removeWhere((item) => item.id == movie.id);

    _recentlyViewed.insert(0, movie);

    notifyListeners();
  }

  void removeRecentlyViewed(int movieId) {
    _recentlyViewed.removeWhere((movie) => movie.id == movieId);

    notifyListeners();
  }

  void clearRecentlyViewed() {
    _recentlyViewed.clear();
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
