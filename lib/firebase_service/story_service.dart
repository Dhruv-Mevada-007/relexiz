// lib/services/story_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model_classes/story_model_class.dart';

class StoryService {
  final storyRef = FirebaseFirestore.instance.collection("stories");

  Future<List<StoryModel>> getStoriesOnce() async {
    final snap = await storyRef.orderBy("date", descending: true).get();
    return snap.docs.map((d) => StoryModel.fromDoc(d)).toList();
  }

  Future<String> addStoryReturnId(StoryModel story) async {
    final doc = await storyRef.add(story.toMap());
    return doc.id;
  }

  Future<void> deleteStory(String id) async {
    await storyRef.doc(id).delete();
  }

  Future<void> updateStory(StoryModel story) async {
    await storyRef.doc(story.id).update(story.toMap());
  }
}
