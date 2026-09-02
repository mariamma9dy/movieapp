class MovieDetailsModel {
  final int runtime;
  final List<String> genres;

  MovieDetailsModel({
    required this.runtime,
    required this.genres,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List? ?? [])
          .map((genre) => genre['name'] as String)
          .toList(),
    );
  }
}