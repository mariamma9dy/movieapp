import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Controllers/FirebaseAuthController.dart';
import 'package:movieapp/Controllers/MovieController.dart';
import 'package:movieapp/Providers/FirebaseAuthProvider.dart';
import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Views/Screens/FavoritesScreen.dart';
import 'package:movieapp/Views/Screens/LogInScreen.dart';
import 'package:movieapp/Views/Screens/MyListScreen.dart';
import 'package:movieapp/Views/Widgets/MovieCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseAuthController authController;
  late MovieController movieController;

  final TextEditingController searchController = TextEditingController();

  bool _moviesLoaded = false;
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: false,
    );

    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    authController = FirebaseAuthController(provider: authProvider);

    movieController = MovieController(provider: movieProvider);

    if (!_moviesLoaded) {
      _moviesLoaded = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await movieController.loadLocalMovies();
        await movieController.getMovies();
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // MARK: - Logout

  Future<void> logOut() async {
    final success = await authController.logOut();

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LogInScreen()),
        (route) => false,
      );
    }
  }

  // MARK: - Search

  void searchMovies(String value) {
    movieController.searchMovies(value);
  }

  // MARK: - Movie Section

  Widget _buildMovieSection({required String title, required List movies}) {
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 12);
            },
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

  // MARK: - Search Results

  Widget _buildSearchResults(MovieProvider provider) {
    if (provider.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.searchErrorMessage != null) {
      return Center(
        child: Text(provider.searchErrorMessage!, textAlign: TextAlign.center),
      );
    }

    if (provider.searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No animation movies found.',
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
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: provider.searchResults[index]);
      },
    );
  }

  // MARK: - Home Movies

  Widget _buildMovies(MovieProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage!, textAlign: TextAlign.center),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: movieController.getMovies,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: movieController.getMovies,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
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

  // MARK: - Home Body

  Widget _buildHomeBody(MovieProvider provider) {
    return Column(
      children: [
        // Search Field
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: TextField(
            controller: searchController,
            onChanged: searchMovies,
            decoration: InputDecoration(
              hintText: 'Search animation movies...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        provider.clearSearchResults();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        // Content
        Expanded(
          child: searchController.text.trim().isNotEmpty
              ? _buildSearchResults(provider)
              : _buildMovies(provider),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'ToonBox'
              : _currentIndex == 1
              ? 'Favourites'
              : 'My List',
        ),
        actions: [
          IconButton(onPressed: logOut, icon: const Icon(Icons.logout)),
        ],
      ),

      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (_currentIndex == 0) {
            return _buildHomeBody(provider);
          }

          if (_currentIndex == 1) {
            return const FavoritesScreen();
          }

          return const MyListScreen();
        },
      ),

      // MARK: - Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            activeIcon: Icon(Icons.playlist_play),
            label: 'My List',
          ),
        ],
      ),
    );
  }
}
