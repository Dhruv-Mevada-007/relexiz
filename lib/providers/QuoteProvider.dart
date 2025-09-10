import 'package:flutter/material.dart';
import '../firebase_service/FirebaseService.dart';
import '../model_classes/QuotesModelClass.dart';

class QuoteProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Quote> _quotes = [];
  int _currentIndex = 0;

  List<Quote> get quotes => _quotes;
  int get currentIndex => _currentIndex;

  Quote? get currentQuote =>
      _quotes.isNotEmpty ? _quotes[_currentIndex] : null;

  Future<void> loadQuotes() async {
    _quotes = await _firebaseService.fetchQuotes();
    notifyListeners();
  }

  void nextQuote() {
    if (_quotes.isNotEmpty) {
      _currentIndex = (_currentIndex + 1) % _quotes.length;
      notifyListeners();
    }
  }

  void previousQuote() {
    if (_quotes.isNotEmpty) {
      _currentIndex = (_currentIndex - 1 + _quotes.length) % _quotes.length;
      notifyListeners();
    }
  }

}
