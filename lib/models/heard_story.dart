import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emotion.dart';

class HeardStory {
  final String id;
  final String quote;
  final EmotionType emotionType;
  final int meTooCount;
  final DateTime createdAt;
  bool didRelate; // local state only

  HeardStory({
    required this.id,
    required this.quote,
    required this.emotionType,
    required this.meTooCount,
    required this.createdAt,
    this.didRelate = false,
  });

  factory HeardStory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HeardStory(
      id: doc.id,
      quote: data['quote'] ?? '',
      emotionType: EmotionType.values.firstWhere(
        (e) => e.name == (data['emotionType'] ?? 'justOff'),
        orElse: () => EmotionType.justOff,
      ),
      meTooCount: data['meTooCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'quote': quote,
        'emotionType': emotionType.name,
        'meTooCount': meTooCount,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  String get emotionLabel {
    switch (emotionType) {
      case EmotionType.anxious:
        return 'anxious';
      case EmotionType.angry:
        return 'angry';
      case EmotionType.sad:
        return 'sad';
      case EmotionType.numb:
        return 'numb';
      case EmotionType.overwhelmed:
        return 'overwhelmed';
      case EmotionType.justOff:
        return 'just off';
    }
  }

  String get meTooDisplay {
    if (meTooCount >= 1000) {
      return '${(meTooCount / 1000).toStringAsFixed(1)}k';
    }
    return meTooCount.toString();
  }
}

// Fallback stories for when Firebase is loading / offline
final List<HeardStory> seedStories = [
  HeardStory(
    id: 'seed_1',
    quote:
        'I canceled plans and felt relieved and guilty at the exact same time. Both feelings were true.',
    emotionType: EmotionType.anxious,
    meTooCount: 241,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  HeardStory(
    id: 'seed_2',
    quote:
        'Some days getting out of bed is genuinely the hardest thing I did. And I still count it.',
    emotionType: EmotionType.sad,
    meTooCount: 887,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  HeardStory(
    id: 'seed_3',
    quote:
        'I snapped at someone I love because I was carrying too much. I felt terrible. I\'m still a good person.',
    emotionType: EmotionType.angry,
    meTooCount: 1243,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  HeardStory(
    id: 'seed_4',
    quote:
        'I\'ve been "fine" for so long I forgot I was allowed to not be fine.',
    emotionType: EmotionType.overwhelmed,
    meTooCount: 3412,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  HeardStory(
    id: 'seed_5',
    quote:
        'I sat on my phone for two hours doing nothing important. I needed that more than anyone knew.',
    emotionType: EmotionType.anxious,
    meTooCount: 567,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  HeardStory(
    id: 'seed_6',
    quote:
        'I pretended to be asleep so I didn\'t have to answer a message. I don\'t feel bad about it.',
    emotionType: EmotionType.overwhelmed,
    meTooCount: 2108,
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
  HeardStory(
    id: 'seed_7',
    quote:
        'My body just stopped. I couldn\'t cry, couldn\'t think. I just sat there. Eventually it passed.',
    emotionType: EmotionType.numb,
    meTooCount: 789,
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
  ),
  HeardStory(
    id: 'seed_8',
    quote:
        'I drove around for an hour because I wasn\'t ready to go home and face the silence.',
    emotionType: EmotionType.sad,
    meTooCount: 1034,
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
  ),
];
