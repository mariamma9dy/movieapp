import 'package:movieapp/Models/MovieModel.dart';
import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Services/HiveService.dart';
import 'package:movieapp/Services/TMDBService.dart';
import 'package:movieapp/Models/MovieDetailsModel.dart';

class MovieController {
  final MovieProvider provider;
  final TMDBService _tmdbService;
  final HiveService _hiveService;

  MovieController({
    required this.provider,
    TMDBService? tmdbService,
    HiveService? hiveService,
  }) : _tmdbService = tmdbService ?? TMDBService(),
       _hiveService = hiveService ?? HiveService();

  // MARK: - Get Movie Details
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    return await _tmdbService.getMovieDetails(movieId);
  }

  // MARK: - Get Home Movies

  Future<void> getMovies() async {
    //print('REFRESH CALLED');
    provider.setLoading(true);
    provider.setError(null);

    try {
      final results = await Future.wait([
        _tmdbService.getPopularAnimationMovies(),
        _tmdbService.getTopRatedAnimationMovies(),
        _tmdbService.getNowPlayingAnimationMovies(),
      ]);

      provider.setPopularMovies(results[0].results);
      provider.setTopRatedMovies(results[1].results);
      provider.setNowPlayingMovies(results[2].results);
    } catch (error) {
      provider.setError('Failed to load movies. Please try again.');
    } finally {
      provider.setLoading(false);
    }
  }

  // MARK: - Search Movies

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      provider.clearSearchResults();
      return;
    }

    provider.setSearching(true);
    provider.setSearchError(null);

    try {
      final result = await _tmdbService.searchAnimationMovies(query.trim());

      provider.setSearchResults(result.results);
    } catch (error) {
      provider.setSearchError('Failed to search movies. Please try again.');
    } finally {
      provider.setSearching(false);
    }
  }

  // MARK: - Load Local Data

  Future<void> loadLocalMovies() async {
    provider.setFavorites(_hiveService.getFavorites());

    provider.setMyList(_hiveService.getMyList());

    provider.setRecentlyViewed(_hiveService.getRecentlyViewed());
  }

  // MARK: - Favorites

  Future<void> toggleFavorite(Movie movie) async {
    if (provider.isFavorite(movie.id)) {
      await _hiveService.removeFromFavorites(movie.id);
      provider.removeFavorite(movie.id);
    } else {
      await _hiveService.addToFavorites(movie);
      provider.addFavorite(movie);
    }
  }

  // MARK: - My List

  Future<void> toggleMyList(Movie movie) async {
    if (provider.isInMyList(movie.id)) {
      await _hiveService.removeFromMyList(movie.id);
      provider.removeMovieFromList(movie.id);
    } else {
      await _hiveService.addToMyList(movie);
      provider.addMovieToList(movie);
    }
  }

  // MARK: - Recently Viewed

  Future<void> addToRecentlyViewed(Movie movie) async {
    await _hiveService.addToRecentlyViewed(movie);
    provider.addRecentlyViewed(movie);
  }
}
