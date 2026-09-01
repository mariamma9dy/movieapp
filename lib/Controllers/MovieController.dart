import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Services/TMDBService.dart';

class MovieController {
  final MovieProvider provider;
  final TMDBService _tmdbService;

  MovieController({
    required this.provider,
    TMDBService? tmdbService,
  }) : _tmdbService = tmdbService ?? TMDBService();

  // MARK: - Get Home Movies
  Future<void> getMovies() async {
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
      provider.setError(
        'Failed to load movies. Please try again.',
      );
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
      final result = await _tmdbService.searchAnimationMovies(
        query.trim(),
      );

      provider.setSearchResults(result.results);
    } catch (error) {
      provider.setSearchError(
        'Failed to search movies. Please try again.',
      );
    } finally {
      provider.setSearching(false);
    }
  }
}

