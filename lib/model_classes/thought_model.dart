class ThoughtModel {
  final String? id;
  final String? title;
  final String? description;
  final String? category;
  final String? mood;
  final DateTime? date;

  ThoughtModel({
    this.id,
    this.title,
    this.description,
    this.category,
    this.mood,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'mood': mood,
      'date': date?.toIso8601String(),
    };
  }

  factory ThoughtModel.fromMap(Map<String, dynamic> map, String id) {
    return ThoughtModel(
      id: id,
      title: map['title'],
      description: map['description'],
      category: map['category'],
      mood: map['mood'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
    );
  }
}
