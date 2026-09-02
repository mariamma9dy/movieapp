import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Models/MovieModel.dart';
import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Controllers/MovieController.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // MARK: - Movie Header

          SliverAppBar(
            expandedHeight: 430,
            pinned: true,
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 16,
              ),
              title: Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (movie.backdropPath != null)
                    Image.network(
                      'https://image.tmdb.org/t/p/w780${movie.backdropPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return _buildPlaceholder();
                      },
                    )
                  else if (movie.posterPath != null)
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return _buildPlaceholder();
                      },
                    )
                  else
                    _buildPlaceholder(),

                  // MARK: - Dark Gradient

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black,
                        ],
                        stops: const [
                          0.0,
                          0.55,
                          1.0,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // MARK: - Movie Content

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MARK: - Rating, Release Date and Language

                  Row(
                    children: [
                      _buildInfoItem(
                        icon: Icons.star,
                        iconColor: Colors.amber,
                        text: movie.voteAverage.toStringAsFixed(1),
                      ),

                      const SizedBox(width: 22),

                      _buildInfoItem(
                        icon: Icons.calendar_today_outlined,
                        text: movie.releaseDate.isEmpty
                            ? 'Unknown'
                            : movie.releaseDate,
                      ),

                      const Spacer(),

                      _buildInfoItem(
                        icon: Icons.language,
                        text: movie.originalLanguage.toUpperCase(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // MARK: - Overview

                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    movie.overview.isEmpty
                        ? 'No overview available for this movie.'
                        : movie.overview,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.grey.shade300,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // MARK: - Favourite Button

                  Consumer<MovieProvider>(
                    builder: (context, provider, child) {
                      final isFavorite = provider.isFavorite(movie.id);

                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
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
                          ),
                          label: Text(
                            isFavorite
                                ? 'Remove from Favourites'
                                : 'Add to Favourites',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // MARK: - My List Button

                  Consumer<MovieProvider>(
                    builder: (context, provider, child) {
                      final isInMyList = provider.isInMyList(movie.id);

                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final controller = MovieController(
                              provider: provider,
                            );

                            await controller.toggleMyList(movie);
                          },
                          icon: Icon(
                            isInMyList
                                ? Icons.playlist_add_check
                                : Icons.playlist_add,
                          ),
                          label: Text(
                            isInMyList
                                ? 'Remove from My List'
                                : 'Add to My List',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - Info Item

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    Color? iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // MARK: - Placeholder

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade900,
      child: const Center(
        child: Icon(
          Icons.movie_outlined,
          size: 70,
          color: Colors.white54,
        ),
      ),
    );
  }
}