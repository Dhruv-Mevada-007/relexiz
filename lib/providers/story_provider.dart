import 'package:flutter/material.dart';
import 'package:relaxiz/firebase_service/story_service.dart';
import '../model_classes/story_model_class.dart';


class StoriesProvider with ChangeNotifier {
  final StoryService _firebase = StoryService();

  List<StoryModel> _stories = [];
  List<StoryModel> get stories => _stories;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  // Filtered stories
  List<StoryModel> get filteredStories {
    if (_selectedCategory == null || _selectedCategory == "All") {
      return _stories;
    }
    return _stories
        .where((s) =>
    s.category?.toLowerCase() == _selectedCategory!.toLowerCase())
        .toList();
  }

  // Dynamic categories
  List<String> get categories {
    final cats = _stories
        .map((s) => s.category)
        .where((c) => c != null && c!.trim().isNotEmpty)
        .map((c) => c!.trim())
        .toSet()
        .toList();

    cats.sort();
    return ["All", ...cats];
  }

  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Load once
  Future<void> loadStories() async {
    final fetched = await _firebase.getStoriesOnce();
    _stories = fetched;
    notifyListeners();
    // addSampleStories();
  }

  // Add Story
  Future<void> addStory(StoryModel story) async {
    final id = await _firebase.addStoryReturnId(story);

    _stories.insert(
      0,
      StoryModel(
        id: id,
        category: story.category,
        emotion: story.emotion,
        title: story.title,
        content: story.content,
        date: story.date,
      ),
    );

    notifyListeners();
  }

  // Delete Story
  Future<void> deleteStory(String id) async {
    await _firebase.deleteStory(id);

    final removed = _stories.firstWhere((s) => s.id == id);
    final removedCat = removed.category;

    _stories.removeWhere((s) => s.id == id);

    final stillExists = _stories.any((s) =>
    s.category?.toLowerCase() == removedCat?.toLowerCase());

    if (!stillExists) {
      _selectedCategory = null; // reset filter
    }

    notifyListeners();
  }

  // Update Story
  Future<void> updateStory(StoryModel story) async {
    await _firebase.updateStory(story);

    final index = _stories.indexWhere((s) => s.id == story.id);
    _stories[index] = story;

    notifyListeners();
  }


  // Add sample long stories (100–200 words)
  Future<void> addSampleStories() async {
    final samples = [
      StoryModel(
        title: "The Quiet Morning",
        category: "Mindfulness",
        content: "The morning was unusually quiet. The kind of quiet that doesn’t feel empty, but full. Sunlight slipped through the curtains, gently touching the floor like it was afraid to wake the world too fast. For once, there was no rush. No notifications screaming for attention. Just breath and presence. She sat by the window, holding a warm cup of tea, feeling the steam rise and disappear. In that moment, she realized how rarely she allowed herself to simply exist. No goals. No pressure. Just being. The world outside continued as always, but inside, something softened. She understood that peace doesn’t arrive loudly — it whispers. And if you listen closely, it’s always been there.",
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),

      StoryModel(
        title: "The Weight We Carry",
        category: "Reflection",
        content: "Everyone carries something invisible. A memory. A regret. A fear they never speak aloud. Some carry expectations placed on them by others, while some carry the weight of their own doubts. He realized this while watching people pass by — each with their own silent battles. And suddenly, his own struggles felt lighter. Not smaller, but understood. That day, he decided to be gentler — with himself and with others. Because kindness, he realized, costs nothing, but heals more than we imagine.",
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),

      StoryModel(
        title: "Learning to Pause",
        category: "Calm",
        content: "Life often feels like a race with no finish line. Always moving. Always chasing something just ahead. But one evening, she stopped. Not because she was tired, but because she chose to. She watched the sky change colors slowly, like a painting in motion. In that pause, she felt something rare — contentment. She learned that pausing isn’t falling behind. Sometimes, it’s how you find yourself again.",
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),

      StoryModel(
        title: "The Soft Strength",
        category: "Healing",
        content: "Strength doesn’t always roar.Sometimes it whispers, 'Try again tomorrow'.After everything she had been through, she still showed up.Still cared. Still hoped.That was her quiet strength.Healing wasn’t a straight path.It twisted, slowed, and sometimes went backward.But every small step counted.And in that realization, she found peace — not because everything was fixed,but because she believed it could be.",
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];

    for (final story in samples) {
      final id = await _firebase.addStoryReturnId(story);

      _stories.insert(
        0,
        StoryModel(
          id: id,
          title: story.title,
          content: story.content,
          emotion: story.emotion,
          category: story.category,
          date: story.date,
        ),
      );
    }

    notifyListeners();
  }


}
