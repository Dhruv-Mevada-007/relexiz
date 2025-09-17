import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relaxiz/pages/pg_list_page.dart';
import 'package:relaxiz/providers/pg_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(  apiKey: "AIzaSyBfkkSgNW6dcbr0IPnPGJlMvqHuZfbeLZk",
          authDomain: "relaxiz.firebaseapp.com",
          projectId: "relaxiz",
          storageBucket: "relaxiz.firebasestorage.app",
          messagingSenderId: "737973340039",
          appId: "1:737973340039:web:a59efed9dc11e6214fb522",
          measurementId: "G-1H8MVP0LHJ")
    );
  }else {
    await Firebase.initializeApp();
  }
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PGProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PG Helper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PGListPage(),
    );
  }
}
