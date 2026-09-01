import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Controllers/FirebaseAuthController.dart';
import 'package:movieapp/Providers/FirebaseAuthProvider.dart';
import 'package:movieapp/Views/Screens/LogInScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {  

  late FirebaseAuthController authController;

  // MARK:- Provider & Controller

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: false,
    );

    authController = FirebaseAuthController(
      provider: provider,
    );
  }

  // MARK:- Logout

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

  // MARK:- UI

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FirebaseAuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          IconButton(
            onPressed: provider.isLoading ? null : logOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}