import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relaxiz/pages/thoughts_list_screen.dart';

import '../providers/access_provider.dart';
import '../providers/activities_provider.dart';
import '../providers/emotion_provider.dart';
import '../providers/quote_provider.dart';
import '../providers/story_provider.dart';
import '../providers/suggestions_provider.dart';
import 'access_gate_screen.dart';
import 'emotion_flow_screen.dart';
import 'quote_screen.dart';
import 'story_screen.dart';
import 'suggestion_screen.dart';
import 'activity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    Future.microtask(() {
      Provider.of<QuotesProvider>(context, listen: false).loadQuotes();
      Provider.of<ActivitiesProvider>(context, listen: false)
          .loadActivities();
      Provider.of<SuggestionsProvider>(context, listen: false)
          .loadSuggestions();
      Provider.of<StoriesProvider>(context, listen: false).loadStories();
      Provider.of<AccessProvider>(context, listen: false).reset();
    });

  }

  @override
  Widget build(BuildContext context) {

    final emotions = context.watch<EmotionProvider>().emotions;


    return Scaffold(
      backgroundColor: const Color(0xFF0D1321),
      body: Stack(
        children: [
          _background(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 20),

                    const Text(
                      "Relaxiz",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "How are you feeling right now?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 24),

                    ListView.builder(
                      itemCount: emotions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        final e = emotions[i];
                        return _emotionCard(context, e);
                      },
                    ),

                    const SizedBox(height: 30),


                    Text(
                      "Slow down. Breathe. Feel better.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 40),

                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [

                        _homeCard(
                          title: "Quotes",
                          subtitle: "Short thoughts to calm your mind",
                          icon: Icons.format_quote_rounded,
                          onTap: () => _go(context, const QuoteScreen()),
                        ),

                        _homeCard(
                          title: "Stories",
                          subtitle: "Slow stories to relax & reflect",
                          icon: Icons.menu_book_rounded,
                          onTap: () => _go(context, const StoryScreen()),
                        ),

                        _homeCard(
                          title: "Suggestions",
                          subtitle: "Small steps to feel better",
                          icon: Icons.lightbulb_outline,
                          onTap: () => _go(context, const SuggestionScreen()),
                        ),

                        _homeCard(
                          title: "Activities",
                          subtitle: "Simple activities for your mind",
                          icon: Icons.self_improvement,
                          onTap: () => _go(context, const ActivityScreen()),
                        ),

                        _homeCard(
                          title: "Mind Dump Journal",
                          subtitle: "Speak out your mind to feel batter",
                          icon: Icons.broken_image_rounded,
                          onTap: () => _go(context, const AccessGateScreen()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _emotionCard(BuildContext context, emotion) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmotionFlowScreen(emotion: emotion),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Text(emotion.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emotion.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  emotion.subtitle,
                  style: const TextStyle(color: Colors.white60),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 🌫 Background
  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D1321),
                Color(0xFF1B2A49),
                Color(0xFF0D1321),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          top: 100,
          left: -60,
          child: _glow(160, Colors.purpleAccent.withOpacity(0.25)),
        ),

        Positioned(
          bottom: 120,
          right: -60,
          child: _glow(180, Colors.blueAccent.withOpacity(0.25)),
        ),
      ],
    );
  }

  // 🌟 Glass Card
  Widget _homeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.chevron_right, color: Colors.white54),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 80,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
