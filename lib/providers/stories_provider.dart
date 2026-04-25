import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/heard_story.dart';

class StoriesProvider extends ChangeNotifier {
  List<HeardStory> _stories = List.from(seedStories);
  bool _loading = false;
  Set<String> _relatedIds = {};

  List<HeardStory> get stories => _stories;
  bool get loading => _loading;

  StoriesProvider() {
    _loadRelatedIds();
    _fetchStories();
  }

  Future<void> _loadRelatedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('related_story_ids') ?? [];
    _relatedIds = Set.from(ids);
    for (final story in _stories) {
      story.didRelate = _relatedIds.contains(story.id);
    }
    notifyListeners();
  }

  Future<void> _fetchStories() async {
    _loading = true;
    notifyListeners();
    try {
      final snap = await FirebaseFirestore.instance
          .collection('heard_stories')
          .orderBy('meTooCount', descending: true)
          .limit(30)
          .get();

      if (snap.docs.isNotEmpty) {
        _stories = snap.docs.map((d) {
          final story = HeardStory.fromFirestore(d);
          story.didRelate = _relatedIds.contains(story.id);
          return story;
        }).toList();
      }
    } catch (_) {
      // fallback to seed data — already set
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> toggleRelate(HeardStory story) async {
    final idx = _stories.indexWhere((s) => s.id == story.id);
    if (idx == -1) return;

    final wasRelated = _stories[idx].didRelate;
    _stories[idx].didRelate = !wasRelated;
    final delta = wasRelated ? -1 : 1;

    // Update local state optimistically
    final updated = HeardStory(
      id: _stories[idx].id,
      quote: _stories[idx].quote,
      emotionType: _stories[idx].emotionType,
      meTooCount: _stories[idx].meTooCount + delta,
      createdAt: _stories[idx].createdAt,
      didRelate: !wasRelated,
    );
    _stories[idx] = updated;
    notifyListeners();

    // Persist locally
    if (!wasRelated) {
      _relatedIds.add(story.id);
    } else {
      _relatedIds.remove(story.id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('related_story_ids', _relatedIds.toList());

    // Sync to Firebase if available
    try {
      await FirebaseFirestore.instance
          .collection('heard_stories')
          .doc(story.id)
          .update({'meTooCount': FieldValue.increment(delta)});
    } catch (_) {
      // offline — local state is fine
    }
  }
}
