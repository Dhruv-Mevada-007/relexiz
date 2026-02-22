import 'package:flutter/material.dart';

import '../model_classes/emotion_model.dart';

class EmotionProvider with ChangeNotifier {
  final List<EmotionModel> emotions = [
    EmotionModel(
      id: "1",
      title: "I want to feel calm",
      subtitle: "Slow things down",
      emoji: "🌿",
      key: "calm",
    ),
    EmotionModel(
      id: "2",
      title: "I'm feeling anxious",
      subtitle: "Too many thoughts",
      emoji: "🌊",
      key: "anxious",
    ),
    EmotionModel(
      id: "3",
      title: "I feel low",
      subtitle: "Need comfort",
      emoji: "🌧️",
      key: "sad",
    ),
    EmotionModel(
      id: "4",
      title: "Everything feels heavy",
      subtitle: "Overwhelmed",
      emoji: "🌫️",
      key: "overwhelmed",
    ),
    EmotionModel(
      id: "5",
      title: "I need motivation",
      subtitle: "Push forward",
      emoji: "🔥",
      key: "motivated",
    ),
  ];
}
