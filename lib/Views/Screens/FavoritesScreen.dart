import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Views/Widgets/MovieCard.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        if (provider.favorites.isEmpty) {
          return const Center(
            child: Text(
              'No favourite movies yet.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.55,
          ),
          itemCount: provider.favorites.length,
          itemBuilder: (context, index) {
            return MovieCard(
              movie: provider.favorites[index],
            );
          },
        );
      },
    );
  }
}