import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  /// Sign in anonymously — no email, no password, just a private user ID
  static Future<void> signInAnonymously() async {
    if (_auth.currentUser != null) return;
    try {
      await _auth.signInAnonymously();
    } catch (_) {
      // If Firebase isn't configured yet, app still works offline
    }
  }

  static String? get userId => _auth.currentUser?.uid;

  /// Seed initial stories into Firestore (run once from admin)
  static Future<void> seedStories() async {
    final batch = _db.batch();
    final stories = [
      {
        'quote': 'I canceled plans and felt relieved and guilty at the exact same time. Both feelings were true.',
        'emotionType': 'anxious',
        'meTooCount': 241,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'quote': 'Some days getting out of bed is genuinely the hardest thing I did. And I still count it.',
        'emotionType': 'sad',
        'meTooCount': 887,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'quote': 'I snapped at someone I love because I was carrying too much. I felt terrible. I\'m still a good person.',
        'emotionType': 'angry',
        'meTooCount': 1243,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'quote': 'I\'ve been "fine" for so long I forgot I was allowed to not be fine.',
        'emotionType': 'overwhelmed',
        'meTooCount': 3412,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final story in stories) {
      final ref = _db.collection('heard_stories').doc();
      batch.set(ref, story);
    }
    await batch.commit();
  }
}
