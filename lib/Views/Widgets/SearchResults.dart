import 'package:flutter/material.dart';

import 'package:movieapp/Models/MovieModel.dart';
import 'package:movieapp/Views/Widgets/MovieCard.dart';

class SearchResults extends StatelessWidget {
  final bool isSearching;
  final String? errorMessage;
  final List<Movie> movies;

  const SearchResults({
    super.key,
    required this.isSearching,
    required this.errorMessage,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return const Center(
        child: CircularProgressIndicator(), // Loading
      );
    }

    if (errorMessage != null) { 
      return Center(
        child: Text(
          errorMessage!,                   // Error
          textAlign: TextAlign.center,
        ),
      );
    }

    if (movies.isEmpty) {
      return const Center(
        child: Text(
          'No animation movies found.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    // MARK:- Grid view
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.55,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);  // Movie card
      },
    );
  }
}