import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/stories_provider.dart';
import 'screens/main_shell.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Init Firebase (gracefully skip if not configured yet)
  try {
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
    await FirebaseService.signInAnonymously();
  } catch (_) {
    // App runs fully offline without Firebase
  }
  // await FirebaseService.seedStories();
  runApp(const RelaxiZApp());
}

class RelaxiZApp extends StatelessWidget {
  const RelaxiZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => StoriesProvider()),
      ],
      child: MaterialApp(
        title: 'relaxiZ',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const MainShell(),
      ),
    );
  }
}
