import 'package:flutter/material.dart';
import 'package:movieapp/Models/MovieModel.dart';
import 'package:movieapp/Views/Screens/MovieDetailsScreen.dart';
// One movie's data
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Show movie details
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MARK:- Movie image
            Expanded(
              child: movie.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const Center(child: Icon(Icons.movie)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('⭐ ${movie.voteAverage.toStringAsFixed(1)}'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
