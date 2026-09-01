import 'package:flutter/material.dart';
import 'package:movieapp/Models/MovieModel.dart';

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
          //MARK:- Movie Poster / Backdrop
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (movie.backdropPath != null)
                    Image.network(
                      'https://image.tmdb.org/t/p/w780${movie.backdropPath}',
                      fit: BoxFit.cover,
                    )
                  else if (movie.posterPath != null)
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                    ),

                  // Dark overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //MARK:- Movie Information
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  //MARK:- Rating + Release Date
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 22,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 20),

                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        movie.releaseDate.isEmpty
                            ? 'Unknown'
                            : movie.releaseDate,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  //MARK:- Overview
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    movie.overview.isEmpty
                        ? 'No overview available.'
                        : movie.overview,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  //MARK:- Favourite Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // We will connect this to SQFLite later.
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Add to Favourites'),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

