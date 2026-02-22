import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String? id;
  final String? category;
  final String? title;
  final String? content;
  final String? emotion;
  final DateTime? date;

  StoryModel({
    this.id,
    this.category,
    this.title,
    this.content,
    this.emotion,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "title": title,
      "content": content,
      "emotion": emotion,
      "date": date?.toIso8601String(),
    };
  }

  factory StoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoryModel(
      id: doc.id,
      category: data['category'],
      title: data['title'],
      content: data['content'],
      emotion: data['emotion'],
      date: DateTime.parse(data['date']),
    );
  }
}
