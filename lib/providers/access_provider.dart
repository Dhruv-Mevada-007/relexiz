import 'package:flutter/material.dart';
import '../firebase_service/access_service.dart';
import '../model_classes/access_model.dart';

class AccessProvider with ChangeNotifier {
  final AccessService _service = AccessService();

  AccessModel? _user;
  String? _error;
  bool _needsCodeSetup = false;
  bool _isVerified = false;

  AccessModel? get user => _user;
  String? get error => _error;
  bool get needsCodeSetup => _needsCodeSetup;
  bool get isVerified => _isVerified;

  /// Step 1: Check if name exists
  Future<void> checkName(String name) async {
    _error = null;
    _needsCodeSetup = false;
    _isVerified = false;

    final result = await _service.getByName(name.trim());

    if (result == null) {
      _error = "Access denied. This name is not registered.";
      notifyListeners();
      return;
    }

    _user = result;

    // If code not set yet → allow creating one
    if (result.code == null || result.code!.isEmpty) {
      _needsCodeSetup = true;
    }

    notifyListeners();
  }

  /// Step 2: Create code (only for existing users)
  Future<void> createCode(String code) async {
    if (_user == null) return;

    await _service.updateCode(_user!.id!, code);

    _user = AccessModel(
      id: _user!.id,
      name: _user!.name,
      code: code,
      role: _user!.role,
    );

    _needsCodeSetup = false;
    _isVerified = true;

    notifyListeners();
  }

  /// Step 3: Verify existing code
  void verifyCode(String code) {
    if (_user == null) return;

    if (_user!.code == code.trim()) {
      _isVerified = true;
      _error = null;
    } else {
      _error = "Incorrect access code";
    }

    notifyListeners();
  }

  void reset() {
    _user = null;
    _error = null;
    _needsCodeSetup = false;
    _isVerified = false;
    notifyListeners();
  }
}
