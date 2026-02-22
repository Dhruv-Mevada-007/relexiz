import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestionModel {
  final String? id;
  final String? type;         // category (stress/anxiety/etc)
  final String? title;
  final String? description;
  final String? difficulty;   // easy / medium / hard
  final String? time;         // "2 mins"
  final String? emotion;         // "2 mins"
  final DateTime? createdAt;

  SuggestionModel({
    this.id,
    this.type,
    this.title,
    this.description,
    this.difficulty,
    this.time,
    this.createdAt,
    this.emotion,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "title": title,
      "description": description,
      "difficulty": difficulty,
      "time": time,
      "emotion": emotion,
      "createdAt": createdAt?.toIso8601String(),
    };
  }

  factory SuggestionModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SuggestionModel(
      id: doc.id,
      type: data["type"],
      title: data["title"],
      description: data["description"],
      difficulty: data["difficulty"],
      time: data["time"],
      emotion: data["emotion"],
      createdAt: DateTime.parse(data["createdAt"]),
    );
  }
}
