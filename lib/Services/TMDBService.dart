import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:movieapp/Models/MovieModel.dart';
import 'package:movieapp/Models/MovieDetailsModel.dart';

class TMDBService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // MARK: - Get Popular Animation Movies
  Future<MovieModel> getPopularAnimationMovies() async {
    return _getMovies(
      '$_baseUrl/discover/movie'
      '?include_adult=false'
      '&include_video=false'
      '&language=en-US'
      '&page=1'
      '&sort_by=popularity.desc'
      '&with_genres=16',
    );
  }

  // MARK: - Get Top Rated Animation Movies
  Future<MovieModel> getTopRatedAnimationMovies() async {
    return _getMovies(
      '$_baseUrl/discover/movie'
      '?include_adult=false'
      '&include_video=false'
      '&language=en-US'
      '&page=1'
      '&sort_by=vote_average.desc'
      '&vote_count.gte=100'
      '&with_genres=16',
    );
  }

  // MARK: - Get Now Playing Animation Movies
  Future<MovieModel> getNowPlayingAnimationMovies() async {
    return _getMovies(
      '$_baseUrl/movie/now_playing'
      '?language=en-US'
      '&page=1', // all
      filterAnimation: true, // then filter
    );
  }

  // // MARK: - Get New Animation Movies
  // Future<MovieModel> getNewAnimationMovies() async {
  //   return _getMovies(
  //     '$_baseUrl/discover/movie'
  //     '?include_adult=false'
  //     '&include_video=false'
  //     '&language=en-US'
  //     '&page=1'
  //     '&sort_by=release_date.desc'
  //     '&with_genres=16'
  //     '&with_release_type=2|3',
  //   );
  // }

  // MARK: - Search Animation Movies
  Future<MovieModel> searchAnimationMovies(String query) async {
    final encodedQuery = Uri.encodeQueryComponent(query);

    return _getMovies(
      '$_baseUrl/search/movie'
      '?query=$encodedQuery'
      '&language=en-US'
      '&page=1'
      '&include_adult=false',
      filterAnimation: true,
    );
  }

  // MARK: - Get Movie Details
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final accessToken = dotenv.env['TMDB_ACCESS_TOKEN'];

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('TMDB Access Token is missing');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId?language=en-US'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return MovieDetailsModel.fromJson(data);
    }

    throw Exception('Failed to load movie details: ${response.statusCode}');
  }

  // MARK: - Get Movies
  Future<MovieModel> _getMovies(
    String url, {
    bool filterAnimation = false,
  }) async {
    final accessToken = dotenv.env['TMDB_ACCESS_TOKEN'];

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('TMDB Access Token is missing');
    }
    // request
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'accept': 'application/json',
      },
    );
    // if accepted
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // from map to model
      final movieModel = MovieModel.fromJson(data);

      // Animation Filter
      if (filterAnimation) {
        final animationMovies = movieModel.results
            .where((movie) => movie.genreIds.contains(16))
            .toList();

        return MovieModel(
          page: movieModel.page,
          results: animationMovies,
          totalPages: movieModel.totalPages,
          totalResults: animationMovies.length,
        );
      }

      return movieModel;
    }

    throw Exception('Failed to load movies: ${response.statusCode}');
  }
}
