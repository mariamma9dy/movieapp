import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Services/TMDBService.dart';

class MovieController {
  final MovieProvider provider;
  final TMDBService _tmdbService;
  // Constructor
  MovieController({
    required this.provider,
    TMDBService? tmdbService,
  }) : _tmdbService = tmdbService ?? TMDBService();

  //MARK:- Get Movies

  Future<void> getMovies() async {
    provider.setLoading(true);
    provider.setError(null);
    // Lists
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
}

