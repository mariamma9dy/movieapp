import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Models/MovieModel.dart';
import 'package:movieapp/Models/MovieDetailsModel.dart';
import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Controllers/MovieController.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late MovieController movieController;

  MovieDetailsModel? movieDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<MovieProvider>(
      context,
      listen: false,
    );

    movieController = MovieController(
      provider: provider,
    );

    loadMovieDetails();
  }
  //MARK:- Load Movie Details
  Future<void> loadMovieDetails() async {
    try {
      final result = await movieController.getMovieDetails(
        widget.movie.id,
      );

      if (!mounted) return;

      setState(() {
        movieDetails = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Failed to load movie details.';
        isLoading = false;
      });
    }
  }
  //MARK:- Format Runtime
  String _formatRuntime(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) {
      return '${remainingMinutes}m';
    }

    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
                widget.movie.title,
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
              //MARK:- Background
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // backdrop
                  if (widget.movie.backdropPath != null)
                    Image.network(
                      'https://image.tmdb.org/t/p/w780${widget.movie.backdropPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return _buildPlaceholder();
                      },
                    )
                  // no backdrop => poster
                  else if (widget.movie.posterPath != null)
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return _buildPlaceholder();
                      },
                    )
                  // no poster
                  else
                    _buildPlaceholder(),

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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //MARK:- Rating, ReleaseDate, Language
                  Row(
                    children: [
                      _buildInfoItem(
                        icon: Icons.star,
                        iconColor: Colors.amber,
                        text: widget.movie.voteAverage
                            .toStringAsFixed(1),
                      ),
                      const SizedBox(width: 22),

                      _buildInfoItem(
                        icon: Icons.calendar_today_outlined,
                        text: widget.movie.releaseDate.isEmpty
                            ? 'Unknown'
                            : widget.movie.releaseDate,
                      ),

                      const Spacer(),

                      _buildInfoItem(
                        icon: Icons.language,
                        text: widget.movie.originalLanguage
                            .toUpperCase(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  //MARK:- Runtime and Genres
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    )
                  else if (movieDetails != null) ...[
                    // Runtime
                    if (movieDetails!.runtime > 0)
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatRuntime(
                              movieDetails!.runtime,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                    // Genres
                    if (movieDetails!.genres.isNotEmpty) ...[
                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: movieDetails!.genres.map((genre) {
                          return Chip(
                            label: Text(genre),
                          );
                        }).toList(),
                      ),
                    ],
                  ],

                  const SizedBox(height: 30),

                  //MARK:- Overview
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.movie.overview.isEmpty
                        ? 'No overview available for this movie.'
                        : widget.movie.overview,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.grey.shade300,
                    ),
                  ),

                  const SizedBox(height: 30),

                  //MARK:- Favourite Button
                  Consumer<MovieProvider>(
                    builder: (context, provider, child) {
                      final isFavorite =
                          provider.isFavorite(widget.movie.id);

                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final controller = MovieController(
                              provider: provider,
                            );

                            await controller.toggleFavorite(
                              widget.movie,
                            );
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

                  //MARK:- My List Button
                  Consumer<MovieProvider>(
                    builder: (context, provider, child) {
                      final isInMyList =
                          provider.isInMyList(widget.movie.id);

                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final controller = MovieController(
                              provider: provider,
                            );

                            await controller.toggleMyList(
                              widget.movie,
                            );
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
  //MARK:- InfoItem
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
  //MARK:- Placeholder
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