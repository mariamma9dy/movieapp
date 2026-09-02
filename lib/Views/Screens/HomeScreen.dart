import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Controllers/MovieController.dart';
import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Views/Screens/FavoritesScreen.dart';
import 'package:movieapp/Views/Screens/MyListScreen.dart';
import 'package:movieapp/Views/Screens/ProfileScreen.dart';
import 'package:movieapp/Views/Widgets/MovieSection.dart';
import 'package:movieapp/Views/Widgets/SearchBar.dart';
import 'package:movieapp/Views/Widgets/SearchResults.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieController movieController;

  final TextEditingController searchController = TextEditingController();

  bool _moviesLoaded = false;
  int _currentIndex = 0; // Pages: Home | Favourites | My List

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final movieProvider = Provider.of<MovieProvider>(
      context,
      listen: false,
    );

    movieController = MovieController(
      provider: movieProvider,
    );

    if (!_moviesLoaded) {
      _moviesLoaded = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await movieController.loadLocalMovies(); // Hive
        await movieController.getMovies();  // TMDB
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // MARK: - Search

  void searchMovies(String value) {
    movieController.searchMovies(value);
  }

  void clearSearch(MovieProvider provider) {
    searchController.clear();
    provider.clearSearchResults();
    setState(() {});
  }

  // MARK: - Home Movies

  Widget _buildMovies(MovieProvider provider) {

    // Loading

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),    
      );
    }

    //MARK:- Retry

    if (provider.errorMessage != null) { 
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.errorMessage!,          
              textAlign: TextAlign.center,
            ),

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
      //MARK:- Movie Section
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          MovieSection(
            title: '🔥 Popular Animation',
            movies: provider.popularMovies,
          ),

          MovieSection(
            title: '⭐ Top Rated Animation',
            movies: provider.topRatedMovies,
          ),

          MovieSection(
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
    final isSearching = searchController.text.trim().isNotEmpty;

    return Column(
      children: [
        SearchBarWidget(
          controller: searchController,
          onChanged: searchMovies,
          onClear: () => clearSearch(provider),
        ),

        Expanded(
          child: isSearching
              ? SearchResults(
                  isSearching: provider.isSearching,
                  errorMessage: provider.searchErrorMessage,
                  movies: provider.searchResults,
                )
              : _buildMovies(provider),
        ),
      ],
    );
  }

  // MARK: - AppBar

  String get appBarTitle {
    if (_currentIndex == 0) {
      return 'ToonBox';
    }

    if (_currentIndex == 1) {
      return 'Favourites';
    }

    return 'My List'; // 2
  }

  void openProfile() {       // Profile
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );
  }

  // MARK: - Bottom Navigation

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            onPressed: openProfile,
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),

      // provider(notifyListeners) => rebuild ui 
      
      body: Consumer<MovieProvider>( // from main
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

      //MARK:- UI
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changeTab,
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