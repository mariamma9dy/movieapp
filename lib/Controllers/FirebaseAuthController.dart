import 'package:firebase_auth/firebase_auth.dart';

import 'package:movieapp/Providers/FirebaseAuthProvider.dart';
import 'package:movieapp/Services/FirebaseAuthService.dart';

class FirebaseAuthController {
  final FirebaseAuthProvider provider;
  final FirebaseAuthService _authService;

  // MARK:- Constructor

  FirebaseAuthController({
    required this.provider,
    FirebaseAuthService? authService,
  }) : _authService = authService ?? FirebaseAuthService();

  // MARK:- Login

  Future<bool> logIn({required String email, required String password}) async {
    provider.setLoading(true);
    provider.setError(null);

    try {
      final result = await _authService.logIn(email: email, password: password);

      provider.setCurrentUser(result.user);

      return true;
    } on FirebaseAuthException catch (error) {
      provider.setError(_getErrorMessage(error.code));

      return false;
    } finally {
      provider.setLoading(false);
    }
  }

  // MARK:- Register

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    provider.setLoading(true);
    provider.setError(null);

    try {
        await _authService.register(
        email: email,
        password: password,
      );
      
      await _authService.logOut();
      provider.clearCurrentUser();

      return true;
    } on FirebaseAuthException catch (error) {
      provider.setError(_getErrorMessage(error.code));

      return false;
    } finally {
      provider.setLoading(false);
    }
  }

  // MARK:- Logout

  Future<bool> logOut() async {
    provider.setError(null);

    try {
      await _authService.logOut();

      provider.clearCurrentUser();

      return true;
    } on FirebaseAuthException catch (error) {
      provider.setError(_getErrorMessage(error.code));

      return false;
    }
  }

  // MARK:- Firebase Error Messages

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'invalid-credential':
        return 'Email or password is incorrect.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
        return 'Email or password is incorrect.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }

  // MARK:- Check Auth State

  bool checkAuthState() {
    final user = _authService.currentUser;

    provider.setCurrentUser(user);

    return user != null; // null => login
  }
}
