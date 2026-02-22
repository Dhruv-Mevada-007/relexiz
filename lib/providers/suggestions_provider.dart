import 'package:flutter/material.dart';

import '../firebase_service/suggestion_service.dart';
import '../model_classes/suggestion_model.dart';


class SuggestionsProvider with ChangeNotifier {
  final SuggestionService _firebase = SuggestionService();

  List<SuggestionModel> _suggestions = [];
  List<SuggestionModel> get suggestions => _suggestions;

  String? _selectedType;
  String? get selectedType => _selectedType;

  // Filtered list based on selected type
  List<SuggestionModel> get filteredSuggestions {
    if (_selectedType == null || _selectedType == "All") {
      return _suggestions;
    }

    return _suggestions
        .where((s) =>
    s.type?.toLowerCase() ==
        _selectedType!.toLowerCase())
        .toList();
  }

  // Dynamic category list
  List<String> get types {
    final typeList = _suggestions
        .map((s) => s.type)
        .where((t) => t != null && t!.trim().isNotEmpty)
        .map((t) => t!.trim())
        .toSet()
        .toList();

    typeList.sort();
    return ["All", ...typeList];
  }

  void setTypeFilter(String? type) {
    _selectedType = type;
    notifyListeners();
  }

  // Load once
  Future<void> loadSuggestions() async {
    final fetched = await _firebase.getSuggestionsOnce();
    _suggestions = fetched;
    notifyListeners();
    // addSampleSuggestions();
  }

  // Add suggestion
  Future<void> addSuggestion(SuggestionModel suggestion) async {
    final id = await _firebase.addSuggestionReturnId(suggestion);

    _suggestions.insert(
      0,
      SuggestionModel(
        id: id,
        type: suggestion.type,
        title: suggestion.title,
        emotion: suggestion.emotion,
        description: suggestion.description,
        difficulty: suggestion.difficulty,
        time: suggestion.time,
        createdAt: suggestion.createdAt,
      ),
    );

    notifyListeners();
  }

  // Delete suggestion
  Future<void> deleteSuggestion(String id) async {
    await _firebase.deleteSuggestion(id);

    final removed = _suggestions.firstWhere((s) => s.id == id);
    final removedType = removed.type;

    _suggestions.removeWhere((s) => s.id == id);

    // If no more suggestions in that type → reset filter
    final stillExists = _suggestions.any((s) =>
    s.type?.toLowerCase() == removedType?.toLowerCase());

    if (!stillExists) _selectedType = null;

    notifyListeners();
  }

  // Update suggestion
  Future<void> updateSuggestion(SuggestionModel suggestion) async {
    await _firebase.updateSuggestion(suggestion);

    final index = _suggestions.indexWhere((s) => s.id == suggestion.id);
    _suggestions[index] = suggestion;

    notifyListeners();
  }


  // Add sample suggestions (calm, mindful, practical)
  Future<void> addSampleSuggestions() async {
    final samples = [
      SuggestionModel(
        title: "5-Minute Breathing Reset",
        description:
        "Sit comfortably and close your eyes. Inhale slowly through your nose for 4 seconds, hold for 2 seconds, and exhale gently through your mouth for 6 seconds. Repeat this cycle for 5 minutes. Let your thoughts come and go without judgment. Focus only on your breath and the feeling of air moving through you.",
        type: "Stress",
        difficulty: "Easy",
        time: "5 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),

      SuggestionModel(
        title: "Mindful Walking",
        description:
        "Take a slow walk, indoors or outside. With each step, notice how your feet touch the ground. Feel the movement of your legs and the rhythm of your breathing. Observe the colors, sounds, and textures around you without labeling them. This practice helps bring your mind back into the present moment.",
        type: "Mindfulness",
        difficulty: "Easy",
        time: "10 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),

      SuggestionModel(
        title: "Unclutter Your Mind",
        description:
        "Write down everything that is on your mind without filtering or judging. Don’t worry about grammar or structure. Once finished, read it slowly and notice which thoughts carry emotional weight. This exercise helps release mental clutter and brings clarity.",
        type: "Mental Health",
        difficulty: "Medium",
        time: "10 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),

      SuggestionModel(
        title: "Gentle Body Scan",
        description:
        "Lie down comfortably and bring attention to your toes. Slowly move your focus upward through your body, relaxing each muscle group as you go. If your mind wanders, gently bring it back to your body. This practice encourages deep relaxation and body awareness.",
        type: "Relaxation",
        difficulty: "Medium",
        time: "12 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),

      SuggestionModel(
        title: "Gratitude Reflection",
        description:
        "Think of three small things you’re grateful for today. They don’t have to be big — a warm drink, a kind word, a quiet moment. Allow yourself to fully feel the appreciation. Gratitude helps shift your focus toward positivity.",
        type: "Positivity",
        difficulty: "Easy",
        time: "5 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];

    for (final suggestion in samples) {
      final id = await _firebase.addSuggestionReturnId(suggestion);

      _suggestions.insert(
        0,
        SuggestionModel(
          id: id,
          title: suggestion.title,
          description: suggestion.description,
          type: suggestion.type,
          emotion: suggestion.emotion,
          difficulty: suggestion.difficulty,
          time: suggestion.time,
          createdAt: suggestion.createdAt,
        ),
      );
    }

    notifyListeners();
  }


}
