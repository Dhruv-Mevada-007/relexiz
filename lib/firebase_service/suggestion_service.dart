// lib/services/story_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model_classes/story_model_class.dart';
import '../model_classes/suggestion_model.dart';

class SuggestionService {

  final suggestionRef =
  FirebaseFirestore.instance.collection("suggestions");

  Future<List<SuggestionModel>> getSuggestionsOnce() async {
    final snap = await suggestionRef
        .orderBy("createdAt", descending: true)
        .get();

    return snap.docs.map((d) => SuggestionModel.fromDoc(d)).toList();
  }

  Future<String> addSuggestionReturnId(SuggestionModel suggestion) async {
    final doc = await suggestionRef.add(suggestion.toMap());
    return doc.id;
  }

  Future<void> deleteSuggestion(String id) async {
    await suggestionRef.doc(id).delete();
  }

  Future<void> updateSuggestion(SuggestionModel suggestion) async {
    await suggestionRef.doc(suggestion.id).update(suggestion.toMap());
  }

}
