import 'package:flutter/material.dart';
import 'package:ordms/data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _repo.isAuthenticated;

  Future<bool> googleLogin() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repo.signInWithGoogle();
      _isLoading = false;
      notifyListeners();

      if (user != null) {
        // AppLogger.auth('Google sign-in succeeded for ${user.email}');
        return true;
      } else {
        // AppLogger.auth('Google sign-in cancelled by user');
        return false;
      }
    } catch (e) {
      // AppLogger.error('Auth', 'Google sign-in failed', e);
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signOut() async {
    await _repo.signOut();
    // AppLogger.auth('User signed out');
    notifyListeners();
    return true;
  }
}
