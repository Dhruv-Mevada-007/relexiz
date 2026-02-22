class EmotionModel {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final String key; // used for filtering content

  EmotionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.key,
  });
}
