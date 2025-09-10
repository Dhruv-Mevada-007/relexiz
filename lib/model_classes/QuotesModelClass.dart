class Quote {
  final String id;
  final String text;
  final String author;

  Quote({required this.id, required this.text, required this.author});

  factory Quote.fromMap(Map<String, dynamic> data, String documentId) {
    return Quote(
      id: documentId,
      text: data['text'] ?? '',
      author: data['author'] ?? 'Unknown',
    );
  }
}
