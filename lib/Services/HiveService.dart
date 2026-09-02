import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/Models/MovieModel.dart';

class HiveService {
  static const String _favoritesBoxName = 'favorites';
  static const String _myListBoxName = 'myList';
  static const String _recentlyViewedBoxName = 'recentlyViewed';

  // MARK: - Boxes

  Box get _favoritesBox => Hive.box(_favoritesBoxName);

  Box get _myListBox => Hive.box(_myListBoxName);

  Box get _recentlyViewedBox => Hive.box(_recentlyViewedBoxName);

  // MARK: - Favorites

  List<Movie> getFavorites() {
    return _favoritesBox.values.map((movie) {
      return Movie.fromMap(
        Map<String, dynamic>.from(movie as Map),
      );
    }).toList();
  }

  Future<void> addToFavorites(Movie movie) async {
    await _favoritesBox.put(
      movie.id,
      movie.toMap(),
    );
  }

  Future<void> removeFromFavorites(int movieId) async {
    await _favoritesBox.delete(movieId);
  }

  bool isFavorite(int movieId) {
    return _favoritesBox.containsKey(movieId);
  }

  // MARK: - My List

  List<Movie> getMyList() {
    return _myListBox.values.map((movie) {
      return Movie.fromMap(
        Map<String, dynamic>.from(movie as Map),
      );
    }).toList();
  }

  Future<void> addToMyList(Movie movie) async {
    await _myListBox.put(
      movie.id,
      movie.toMap(),
    );
  }

  Future<void> removeFromMyList(int movieId) async {
    await _myListBox.delete(movieId);
  }

  bool isInMyList(int movieId) {
    return _myListBox.containsKey(movieId);
  }

  // MARK: - Recently Viewed

  List<Movie> getRecentlyViewed() {
    return _recentlyViewedBox.values.map((movie) {
      return Movie.fromMap(
        Map<String, dynamic>.from(movie as Map),
      );
    }).toList()
        .reversed
        .toList();
  }

  Future<void> addToRecentlyViewed(Movie movie) async {
    // Remove the movie first so it does not appear twice.
    await _recentlyViewedBox.delete(movie.id);

    // Add the movie again so it becomes the most recently viewed.
    await _recentlyViewedBox.put(
      movie.id,
      movie.toMap(),
    );

    // Keep only the latest 10 movies.
    final keys = _recentlyViewedBox.keys.toList();

    if (keys.length > 10) {
      await _recentlyViewedBox.delete(keys.first);
    }
  }

  Future<void> removeFromRecentlyViewed(int movieId) async {
    await _recentlyViewedBox.delete(movieId);
  }

  Future<void> clearRecentlyViewed() async {
    await _recentlyViewedBox.clear();
  }
}