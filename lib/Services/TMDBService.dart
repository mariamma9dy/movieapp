import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:movieapp/Models/MovieModel.dart';

class TMDBService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  //MARK:- Get Movies
  Future<MovieModel> _getMovies(String endpoint) async {
    final accessToken = dotenv.env['TMDB_ACCESS_TOKEN'];

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('TMDB Access Token is missing');
    }

    final url = Uri.parse(
      '$_baseUrl/$endpoint'
      '${endpoint.contains('?') ? '&' : '?'}language=en-US&page=1',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return MovieModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load movies: ${response.statusCode}',
      );
    }
  }

  //MARK:- Popular Animation
  Future<MovieModel> getPopularAnimationMovies() {
    return _getMovies(
      'discover/movie?with_genres=16&sort_by=popularity.desc',
    );
  }

  //MARK:- Top Rated Animation
  Future<MovieModel> getTopRatedAnimationMovies() {
    return _getMovies(
      'discover/movie?with_genres=16&sort_by=vote_average.desc&vote_count.gte=100',
    );
  }

  //MARK:- Now Playing Animation
  Future<MovieModel> getNowPlayingAnimationMovies() {
    return _getMovies(
      'discover/movie?with_genres=16&sort_by=primary_release_date.desc',
    );
  }
}

