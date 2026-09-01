import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Controllers/FirebaseAuthController.dart';
import 'package:movieapp/Providers/FirebaseAuthProvider.dart';
import 'package:movieapp/Views/Screens/HomeScreen.dart';
import 'package:movieapp/Views/Screens/LogInScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late FirebaseAuthController authController;

  // MARK:- Initialize

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FirebaseAuthProvider>(
        context,
        listen: false,
      );

      authController = FirebaseAuthController(
        provider: provider,
      );

      checkAuthState();
    });
  }

  // MARK:- Check Auth State

  Future<void> checkAuthState() async {
    // wait 2s after firebase 
    await Future.delayed(const Duration(seconds: 2)); 

    final isLoggedIn = authController.checkAuthState();

    // if screen is closed by user Exit function
    if (!mounted) return; 

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LogInScreen(),
        ),
      );
    }
  }

  // MARK:- UI

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}