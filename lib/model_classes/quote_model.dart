import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  final String? id;
  final String? category;
  final String? text;
  final String? author;
  final DateTime? date;
  final String? emotion;

  QuoteModel({
    this.id,
    this.category,
    this.text,
    this.author,
    this.date,
    this.emotion
  });

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "text": text,
      "author": author,
      "date": date?.toIso8601String(),
      "emotion":emotion

    };
  }

  factory QuoteModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuoteModel(
      id: doc.id,
      category: data['category'],
      text: data['text'],
      author: data['author'],
      date: DateTime.parse(data['date']),
      emotion: data['emotion'],
    );
  }
}
