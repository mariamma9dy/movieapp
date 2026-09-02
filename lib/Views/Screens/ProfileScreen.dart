import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Controllers/FirebaseAuthController.dart';
import 'package:movieapp/Providers/FirebaseAuthProvider.dart';
import 'package:movieapp/Providers/MovieProvider.dart';
import 'package:movieapp/Views/Screens/FavoritesScreen.dart';
import 'package:movieapp/Views/Screens/LogInScreen.dart';
import 'package:movieapp/Views/Screens/MyListScreen.dart';
import 'package:movieapp/Views/Widgets/ProfileOption.dart';
import 'package:movieapp/Views/Screens/RecentlyViewedScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // MARK: - Logout

  Future<void> logOut(BuildContext context) async {
    final authProvider = context.read<FirebaseAuthProvider>();

    final authController = FirebaseAuthController(provider: authProvider);

    final success = await authController.logOut();

    if (!context.mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LogInScreen()),
        (route) => false,
      );
    }
  }

  // MARK: - Open Favorites

  void openFavorites(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
  }

  // MARK: - Open My List

  void openMyList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MyListScreen()),
    );
  }

  // MARK: - UI

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<FirebaseAuthProvider>();
    final movieProvider = context.watch<MovieProvider>();

    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // MARK: - Profile Header
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 45,
              child: Icon(Icons.person_outline, size: 50),
            ),

            const SizedBox(height: 16),

            Text(
              user?.email ?? 'No email',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 35),

            // MARK: - Favorites
            ProfileOption(
              icon: Icons.favorite,
              title: 'Favorites',
              subtitle: 'Your favorite movies',
              count: movieProvider.favorites.length,
              onTap: () => openFavorites(context),
            ),

            const SizedBox(height: 12),

            // MARK: - My List
            ProfileOption(
              icon: Icons.movie_outlined,
              title: 'My List',
              subtitle: 'Movies you want to watch',
              count: movieProvider.myList.length,
              onTap: () => openMyList(context),
            ),

            const SizedBox(height: 12),

            // MARK: - Recently Viewed
            ProfileOption(
              icon: Icons.history,
              title: 'Recently Viewed',
              subtitle: 'Movies you recently viewed',
              count: movieProvider.recentlyViewed.length,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecentlyViewedScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            const Divider(),

            const SizedBox(height: 12),

            // MARK: - Settings
            ProfileOption(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings will be available soon.'),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // MARK: - Logout
            ProfileOption(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => logOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
