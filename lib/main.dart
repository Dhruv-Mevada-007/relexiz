import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relaxiz/pages/emotion_home_screen.dart';
import 'package:relaxiz/pages/home_screen.dart';
import 'package:relaxiz/pages/quote_screen.dart';
import 'package:relaxiz/pages/sample_home_page.dart';
import 'package:relaxiz/pages/thoughts_list_screen.dart';
import 'package:relaxiz/providers/access_provider.dart';
import 'package:relaxiz/providers/activities_provider.dart';
import 'package:relaxiz/providers/emotion_provider.dart';
import 'package:relaxiz/providers/quote_provider.dart';
import 'package:relaxiz/providers/story_provider.dart';
import 'package:relaxiz/providers/suggestions_provider.dart';
import 'package:relaxiz/providers/thought_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBfkkSgNW6dcbr0IPnPGJlMvqHuZfbeLZk",
        authDomain: "relaxiz.firebaseapp.com",
        projectId: "relaxiz",
        storageBucket: "relaxiz.firebasestorage.app",
        messagingSenderId: "737973340039",
        appId: "1:737973340039:web:a59efed9dc11e6214fb522",
        measurementId: "G-1H8MVP0LHJ",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoriesProvider()),
        ChangeNotifierProvider(create: (_) => AccessProvider()),
        ChangeNotifierProvider(create: (_) => EmotionProvider()),
        ChangeNotifierProvider(create: (_) => ThoughtProvider()),
        ChangeNotifierProvider(create: (_) => QuotesProvider()),
        ChangeNotifierProvider(create: (_) => SuggestionsProvider()),
        ChangeNotifierProvider(create: (_) => ActivitiesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardColor: const Color(0xFF1E1E1E),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
        bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
        titleLarge: TextStyle(
          color: Color(0xFFE0E0E0),
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB69EEF),),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF64B5F6), width: 2),
        ),
        labelStyle: const TextStyle(color:Color(0xFFB69EEF),),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFB69EEF),
        foregroundColor: Colors.black,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFB69EEF),
        secondary: Color(0xFF64B5F6),
        surface: Color(0xFF1E1E1E),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),

    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RelaxiZ',
      theme: darkTheme,
      home:

      // ThoughtsListScreen(),
      // HomeScreen(),
      // QuoteScreen()
      // SampleHomePage()
      // EmotionHomeScreen()
      HomeScreen()
    );
  }
}
