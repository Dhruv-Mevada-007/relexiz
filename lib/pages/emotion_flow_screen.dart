import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_classes/emotion_model.dart';
import '../providers/activities_provider.dart';
import '../providers/quote_provider.dart';
import '../providers/story_provider.dart';
import 'emotion_viewer.dart';

class EmotionFlowScreen extends StatelessWidget {
  final EmotionModel emotion;

  const EmotionFlowScreen({super.key, required this.emotion});

  @override
  Widget build(BuildContext context) {
    final quotes = context
        .watch<QuotesProvider>()
        .quotes
        .where((q) => q.emotion == emotion.key)
        .toList();

    final stories = context
        .watch<StoriesProvider>()
        .stories
        .where((s) => s.emotion == emotion.key)
        .toList();

    final activities = context
        .watch<ActivitiesProvider>()
        .activities
        .where((a) => a.emotion == emotion.key)
        .toList();

    final allItems = [
      ...quotes,
      ...stories,
      ...activities,
    ];

    print(quotes.length);

    return EmotionViewer(items: allItems,);
  }
}
