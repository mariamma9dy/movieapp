import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  // MARK:- Variables

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // MARK:- Getters

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // MARK:- Current User

  void setCurrentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  // MARK:- Loading

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // MARK:- Error

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}

