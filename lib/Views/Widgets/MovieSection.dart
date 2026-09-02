import 'package:flutter/material.dart';

import 'package:movieapp/Models/MovieModel.dart';
import 'package:movieapp/Views/Widgets/MovieCard.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    //MARK:- No Movies
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 280,
          //MARK:- List of Movies
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 12);
            },
            //MARK:- Movie card
            itemBuilder: (context, index) {
              return SizedBox(
                width: 155,
                child: MovieCard(movie: movies[index]),
              );
            },
          ),
        ),

        const SizedBox(height: 28),
      ],
    );
  }
}