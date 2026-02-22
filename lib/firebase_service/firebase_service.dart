import 'package:cloud_firestore/cloud_firestore.dart';

import '../model_classes/thought_model.dart';

class FirebaseService {
  final _thoughts = FirebaseFirestore.instance.collection('thoughts');

  // Fetch once (no stream)
  Future<List<ThoughtModel>> getThoughtsOnce() async {
    final snapshot = await _thoughts.orderBy('date', descending: true).get();
    return snapshot.docs
        .map((doc) => ThoughtModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Add and return ID
  Future<String> addThoughtReturnId(ThoughtModel thought) async {
    final docRef = await _thoughts.add(thought.toMap());
    return docRef.id;
  }

  Future<void> deleteThought(String id) async {
    await _thoughts.doc(id).delete();
  }
}
