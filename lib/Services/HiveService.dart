import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/Models/MovieModel.dart';

class HiveService {
  static const String _favoritesBoxName = 'favorites';
  static const String _myListBoxName = 'myList';

  // MARK: - Boxes

  Box get _favoritesBox => Hive.box(_favoritesBoxName);

  Box get _myListBox => Hive.box(_myListBoxName);

  // MARK: - Favorites

  List<Movie> getFavorites() {
    // get all data from hive
    // as map
    return _favoritesBox.values.map((movie) {
      return Movie.fromMap(
        Map<String, dynamic>.from(movie as Map),
      );
    }).toList(); // return movie list
     
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
}