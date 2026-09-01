import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Controllers/FirebaseAuthController.dart';
import 'package:movieapp/Controllers/MovieController.dart';
import 'package:movieapp/Providers/FirebaseAuthProvider.dart';
import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Views/Screens/LogInScreen.dart';
import 'package:movieapp/Views/Widgets/MovieCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseAuthController authController;
  late MovieController movieController;

  bool _moviesLoaded = false;

  // MARK: - Provider & Controller

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: false,
    );

    authController = FirebaseAuthController(
      provider: authProvider,
    );

    final movieProvider = Provider.of<MovieProvider>(
      context,
      listen: false,
    );

    movieController = MovieController(
      provider: movieProvider,
    );

    if (!_moviesLoaded) {
      _moviesLoaded = true;
      movieController.getMovies();
    }
  }

  // MARK: - Logout

  Future<void> logOut() async {
    final success = await authController.logOut();

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LogInScreen(),
        ),
        (route) => false,
      );
    }
  }

  // MARK: - Movie Section

  Widget _buildMovieSection({
    required String title,
    required List movies,
  }) {
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 155,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: MovieCard(
                    movie: movies[index],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 28),
      ],
    );
  }

  // MARK: - Movies

  Widget _buildMovies(MovieProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  
    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
            ),

            const SizedBox(height: 12),

            Text(
              provider.errorMessage!,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: movieController.getMovies,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.popularMovies.isEmpty &&
        provider.topRatedMovies.isEmpty &&
        provider.nowPlayingMovies.isEmpty) {
      return const Center(
        child: Text('No movies found'),
      );
    }

    return RefreshIndicator(
      onRefresh: movieController.getMovies,
      child: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          _buildMovieSection(
            title: '🔥 Popular Animation',
            movies: provider.popularMovies,
          ),

          _buildMovieSection(
            title: '⭐ Top Rated Animation',
            movies: provider.topRatedMovies,
          ),

          _buildMovieSection(
            title: '🆕 New Animation',
            movies: provider.nowPlayingMovies,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // MARK: - UI

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<FirebaseAuthProvider>();
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ToonBox',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: authProvider.isLoading ? null : logOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MARK: - Search Bar

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search animation movies...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // MARK: - Movies

          Expanded(
            child: _buildMovies(movieProvider),
          ),
        ],
      ),

      // MARK: - Bottom Navigation

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

