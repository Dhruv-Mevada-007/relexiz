import 'package:flutter/material.dart';

import '../firebase_service/firebase_service.dart';
import '../model_classes/thought_model.dart';

class ThoughtProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<ThoughtModel> _thoughts = [];
  List<ThoughtModel> get thoughts => _thoughts;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  List<ThoughtModel> get filteredThoughts {
    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      return _thoughts;
    }
    return _thoughts
        .where((t) => t.category?.toLowerCase() == _selectedCategory!.toLowerCase())
        .toList();
  }

  // Get dynamic categories from existing thoughts
  List<String> get categories {
    final cats = _thoughts
        .map((t) => t.category)
        .where((c) => c != null && c!.trim().isNotEmpty)
        .map((c) => c!.trim())
        .toSet() // remove duplicates
        .toList();
    cats.sort(); // optional alphabetical
    return ['All', ...cats]; // always add "All" at the start
  }

  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Load once on page init
  Future<void> loadThoughts() async {
    final fetched = await _firebaseService.getThoughtsOnce();
    _thoughts = fetched;
    notifyListeners();
  }

  // Add new thought
  Future<void> addThought(ThoughtModel thought) async {
    final id = await _firebaseService.addThoughtReturnId(thought);
    _thoughts.insert(0, ThoughtModel(
      id: id,
      title: thought.title,
      description: thought.description,
      category: thought.category,
      mood: thought.mood,
      date: thought.date,
    ));
    notifyListeners();
  }

  // Delete thought locally + Firebase
  Future<void> deleteThought(String id) async {
    await _firebaseService.deleteThought(id);
    _thoughts.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> addSampleThoughts() async {
    final sampleThoughts = [
      ThoughtModel(
        title: 'Uncertainty about the future',
        description:
        'Sometimes I keep wondering if I’m doing enough, or if I’m just drifting along while others move ahead. I replay conversations and decisions, analyzing every small detail, even though I know it won’t change the outcome.',
        category: 'Self Reflection',
        mood: 'Anxious',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ThoughtModel(
        title: 'Morning calm',
        description:
        'Today I woke up early and sat on the balcony. The air was still cool, and everything felt paused for a moment. It reminded me that peace is not something to chase, it’s something I can create by slowing down.',
        category: 'Peace',
        mood: 'Calm',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ThoughtModel(
        title: 'Overanalyzing messages',
        description:
        'I read one text five times trying to understand the tone. I know I shouldn’t assume the worst, but my mind automatically looks for hidden meanings that probably aren’t even there.',
        category: 'Relationships',
        mood: 'Worried',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      // 🔹 Add more 27+ thoughts here
    ];

    // Generate extra random thoughts
    final randomTexts = [
      'Maybe overthinking is just my brain’s way of trying to protect me from surprises, but it often ends up draining me instead.',
      'I replayed the same conversation in my head for hours, trying to think what I could’ve said differently.',
      'The future feels uncertain, but maybe that’s okay — it means anything is still possible.',
      'Sometimes I just want my brain to be quiet for 10 minutes.',
      'When I can’t stop thinking, writing it down seems to make the storm quieter.',
      'I’ve realized most of my worries never actually happen.',
      'Today I tried focusing on breathing whenever I caught myself spiraling. It helped, a little.',
      'I wish I could switch off my thoughts like I switch off my phone.',
      'Maybe progress isn’t about doing more, but about worrying less.',
      'I tend to analyze everything because I’m scared of missing something important.',
    ];

    // for (int i = 0; i < 27; i++) {
    //   sampleThoughts.add(
    //     ThoughtModel(
    //       title: 'Thought ${i + 4}',
    //       description: randomTexts[i % randomTexts.length],
    //       category: i % 2 == 0 ? 'General' : 'Mindfulness',
    //       mood: (['Calm', 'Tired', 'Anxious', 'Neutral', 'Hopeful'])[i % 5],
    //       date: DateTime.now().subtract(Duration(days: i + 4)),
    //     ),
    //   );
    // }
    //
    // // Add to Firebase and local list
    for (final thought in sampleThoughts) {
      final id = await _firebaseService.addThoughtReturnId(thought);
      _thoughts.insert(0, ThoughtModel(
        id: id,
        title: thought.title,
        description: thought.description,
        category: thought.category,
        mood: thought.mood,
        date: thought.date,
      ));
    }

    notifyListeners();
  }

}
