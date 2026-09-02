class MovieModel {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  MovieModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  //MARK:- Model from json
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      page: json['page'] ?? 1,
      results: (json['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList(),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

class Movie {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String title;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });
  //MARK:- Movie from json
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      posterPath: json['poster_path'],
      releaseDate: json['release_date'] ?? '',
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
    );
  }

  // MARK: - Hive

  // Movie => Save Map to Hive
  Map<String, dynamic> toMap() { // stor
    return {
      'adult': adult,
      'backdropPath': backdropPath,
      'genreIds': genreIds,
      'id': id,
      'title': title,
      'originalLanguage': originalLanguage,
      'originalTitle': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
      'video': video,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
    };
  }
  // Map from Hive => Movie
  factory Movie.fromMap(Map<String, dynamic> map) { // read
    return Movie(
      adult: map['adult'] ?? false,
      backdropPath: map['backdropPath'],
      genreIds: List<int>.from(map['genreIds'] ?? []),
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      originalLanguage: map['originalLanguage'] ?? '',
      originalTitle: map['originalTitle'] ?? '',
      overview: map['overview'] ?? '',
      popularity: (map['popularity'] ?? 0).toDouble(),
      posterPath: map['posterPath'],
      releaseDate: map['releaseDate'] ?? '',
      video: map['video'] ?? false,
      voteAverage: (map['voteAverage'] ?? 0).toDouble(),
      voteCount: map['voteCount'] ?? 0,
    );
  }
}