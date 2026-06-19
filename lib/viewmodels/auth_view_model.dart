import 'package:flutter/material.dart';
import 'package:ordms/data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  String? _userName;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _repo.isAuthenticated;
  String? get userName => _userName;

  Future<bool> googleLogin() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repo.signInWithGoogle();
      _isLoading = false;
      notifyListeners();

      if (user != null) {
        _userName = user.displayName;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signOut() async {
    await _repo.signOut();
    notifyListeners();
    return true;
  }
}
