import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Views/Widgets/MovieCard.dart';

class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently Viewed'),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.recentlyViewed.isEmpty) {
            return const Center(
              child: Text(
                'You haven\'t viewed any movies yet.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.55,
            ),
            itemCount: provider.recentlyViewed.length,
            itemBuilder: (context, index) {
              return MovieCard(
                movie: provider.recentlyViewed[index],
              );
            },
          );
        },
      ),
    );
  }
}