import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Models/MovieModel.dart';
import 'package:movieapp/Views/Screens/MovieDetailsScreen.dart';
import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Controllers/MovieController.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsScreen(
              movie: movie,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MARK: - Poster

            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (movie.posterPath != null)
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      // Image fails
                      errorBuilder: (_, __, ___) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 40,
                          ),
                        );
                      },
                    )
                  else
                    const Center(
                      child: Icon(
                        Icons.movie_outlined, // No poster
                        size: 40,
                      ),
                    ),

                  // MARK: - Favourite

                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<MovieProvider>(
                      builder: (context, provider, child) {
                        final isFavorite = provider.isFavorite(movie.id);

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final controller = MovieController(
                                provider: provider,
                              );

                              await controller.toggleFavorite(movie);
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: isFavorite
                                  ? Colors.red
                                  : Colors.white,
                            ),
                            padding: const EdgeInsets.all(7),
                            constraints: const BoxConstraints(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // MARK: - Movie Information

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        movie.releaseDate.isEmpty
                            ? 'Unknown'
                            : movie.releaseDate.substring(0, 4),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}