import 'package:flutter/material.dart';
import 'package:relaxiz/pages/quote_screen.dart';
import 'package:relaxiz/pages/story_screen.dart';
import 'package:relaxiz/pages/suggestion_screen.dart';
import 'package:relaxiz/pages/thoughts_list_screen.dart';

import 'activity_screen.dart';

class SampleHomePage extends StatefulWidget {
  const SampleHomePage({super.key});

  @override
  State<SampleHomePage> createState() => _SampleHomePageState();
}

class _SampleHomePageState extends State<SampleHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => QuoteScreen(),));

          }, child: Text("Quotes")),

          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ThoughtsListScreen(),));

          }, child: Text("Thoughts")),


          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen(),));

          }, child: Text("Stories")),

          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SuggestionScreen(),));

          }, child: Text("Suggestions")),

          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityScreen(),));

          }, child: Text("Activities")),
        ],
      ),
    );
  }
}
