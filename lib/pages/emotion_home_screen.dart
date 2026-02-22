import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/emotion_provider.dart';
import '../providers/access_provider.dart';
import '../providers/activities_provider.dart';
import '../providers/quote_provider.dart';
import '../providers/story_provider.dart';
import '../providers/suggestions_provider.dart';
import 'emotion_flow_screen.dart';

class EmotionHomeScreen extends StatefulWidget {
  const EmotionHomeScreen({super.key});

  @override
  State<EmotionHomeScreen> createState() => _EmotionHomeScreenState();
}

class _EmotionHomeScreenState extends State<EmotionHomeScreen> {


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
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "How are you feeling right now?",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: ListView.builder(
                      itemCount: emotions.length,
                      itemBuilder: (_, i) {
                        final e = emotions[i];
                        return _emotionCard(context, e);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
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

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D1321), Color(0xFF1B2A49)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
