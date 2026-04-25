import 'package:flutter/foundation.dart';
import '../models/emotion.dart';

class AppProvider extends ChangeNotifier {
  EmotionType? _selectedEmotion;
  int _currentTab = 0;
  bool _hasCheckedInToday = false;

  EmotionType? get selectedEmotion => _selectedEmotion;
  int get currentTab => _currentTab;
  bool get hasCheckedInToday => _hasCheckedInToday;

  Emotion? get currentEmotionData =>
      _selectedEmotion != null ? EmotionData.byType(_selectedEmotion!) : null;

  void selectEmotion(EmotionType type) {
    _selectedEmotion = type;
    _hasCheckedInToday = true;
    notifyListeners();
  }

  void setTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  void clearEmotion() {
    _selectedEmotion = null;
    notifyListeners();
  }
}
