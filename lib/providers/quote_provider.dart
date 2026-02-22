import 'package:flutter/material.dart';
import 'package:relaxiz/firebase_service/quote_service.dart';
import '../model_classes/quote_model.dart';

class QuotesProvider with ChangeNotifier {
  final QuoteService _firebase = QuoteService();

  List<QuoteModel> _quotes = [];
  List<QuoteModel> get quotes => _quotes;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  // Filtered quotes by category
  List<QuoteModel> get filteredQuotes {
    if (_selectedCategory == null || _selectedCategory == "All") {
      return _quotes;
    }
    return _quotes
        .where((q) =>
    q.category?.toLowerCase() ==
        _selectedCategory!.toLowerCase())
        .toList();
  }

  List<String> get categories {
    final cats = _quotes
        .map((q) => q.category)
        .where((c) => c != null && c!.trim().isNotEmpty)
        .map((c) => c!.trim())
        .toSet()
        .toList();

    cats.sort();
    return ["All", ...cats];
  }


  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Load once
  Future<void> loadQuotes() async {
    final fetched = await _firebase.getQuotesOnce();
    _quotes = fetched;
    notifyListeners();
    // addSampleQuotes();
  }

  // Add a quote locally + Firebase
  Future<void> addQuote(QuoteModel quote) async {
    final id = await _firebase.addQuoteReturnId(quote);

    _quotes.insert(
      0,
      QuoteModel(
        id: id,
        category: quote.category,
        text: quote.text,
        author: quote.author,
        emotion: quote.emotion,
        date: quote.date,
      ),
    );

    notifyListeners();
  }

  // Delete quote
  Future<void> deleteQuote(String id) async {
    await _firebase.deleteQuote(id);

    // find quote first
    final removedQuote = _quotes.firstWhere((q) => q.id == id);
    final removedCategory = removedQuote.category;

    // remove locally
    _quotes.removeWhere((q) => q.id == id);

    // if that category is now empty → remove filter
    final stillExists = _quotes.any((q) =>
    q.category?.toLowerCase() == removedCategory?.toLowerCase());

    if (!stillExists) {
      _selectedCategory = null;   // reset to ALL
    }

    notifyListeners();
  }


  // Add many sample quotes
  Future<void> addSampleQuotes() async {
    final samples = [
      QuoteModel(
        category: "Motivation",
        text: "Believe you can and you're halfway there.",
        author: "Theodore Roosevelt",
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      QuoteModel(
        category: "Life",
        text: "Life is what happens when you're busy making other plans.",
        author: "John Lennon",
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      QuoteModel(
        category: "Stress",
        text: "Do what you can, with what you have, where you are.",
        author: "Unknown",
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    for (final q in samples) {
      final id = await _firebase.addQuoteReturnId(q);

      _quotes.insert(
        0,
        QuoteModel(
          id: id,
          category: q.category,
          text: q.text,
          author: q.author,
          date: q.date,
          emotion: q.emotion
        ),
      );
    }

    notifyListeners();
  }
}
