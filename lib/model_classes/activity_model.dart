import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String? id;
  final String? type;
  final String? title;
  final String? description;
  final String? time;
  final String? difficulty;
  final String? emotion;
  final DateTime? createdAt;

  ActivityModel({
    this.id,
    this.type,
    this.title,
    this.description,
    this.time,
    this.difficulty,
    this.emotion,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "title": title,
      "description": description,
      "time": time,
      "difficulty": difficulty,
      "emotion": emotion,
      "createdAt": createdAt?.toIso8601String(),
    };
  }

  factory ActivityModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityModel(
      id: doc.id,
      type: data["type"],
      title: data["title"],
      description: data["description"],
      time: data["time"],
      difficulty: data["difficulty"],
      emotion: data["emotion"],
      createdAt: DateTime.parse(data["createdAt"]),
    );
  }
}
