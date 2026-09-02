import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

import 'Providers/FirebaseAuthProvider.dart';
import 'Providers/MovieProvider.dart';

import 'Views/Screens/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();

  await Hive.openBox('favorites');
  await Hive.openBox('myList');
  await Hive.openBox('recentlyViewed');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData.dark(),
      //MARK:- Theme
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07131F),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D4FF),
          secondary: Color(0xFF4D7CFE),
          surface: Color(0xFF102235),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A1724),
          foregroundColor: Colors.white,
        ),

        cardTheme: const CardThemeData(color: Color(0xFF102235)),
      ),
      home: const SplashScreen(),
    );
  }
}
