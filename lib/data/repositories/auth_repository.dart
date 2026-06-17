import 'package:firebase_auth/firebase_auth.dart';
import 'package:ordms/data/models/user_model.dart';
import 'package:ordms/data/services/auth_service.dart';
import 'package:ordms/data/services/user_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  /// Sign in with Google and persist user data.
  /// Returns the [user] on success, `null` on failure.
  Future<User?> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        role: '',
        needs: [],
        createdAt: DateTime.now(),
      );
      await _userService.saveUser(userModel);
    }
    return user;
  }

  /// Sign the current user out.
  Future<void> signOut() => _authService.signOut();

  /// Whether a user is currently authenticated.
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  /// The currently signed-in user, or `null`.
  User? get currentUser => FirebaseAuth.instance.currentUser;
}
