import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Views/Widgets/MovieCard.dart';

class MyListScreen extends StatelessWidget {
  final bool showAppBar;

  const MyListScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Consumer<MovieProvider>(
      builder: (context, provider, child) {
        if (provider.myList.isEmpty) {
          return const Center(
            child: Text(
              'Your list is empty.',
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
          itemCount: provider.myList.length,
          itemBuilder: (context, index) {
            return MovieCard(
              movie: provider.myList[index],
            );
          },
        );
      },
    );

    if (!showAppBar) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
      ),
      body: content,
    );
  }
}