import 'package:flutter/material.dart';

import '../firebase_service/FirebaseService.dart';
import '../model_classes/pg_model_class.dart';
class PGProvider with ChangeNotifier {
  List<PG> _pgList = [];
  bool _isLoading = false;

  List<PG> get pgList => _pgList;
  bool get isLoading => _isLoading;

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> loadPGs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _pgList = await _firebaseService.fetchPGs();
    } catch (e) {
      print('Error fetching PGs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
