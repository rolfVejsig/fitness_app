import 'package:flutter/foundation.dart';

import '../services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  bool _isLoading = false;
  String? _message;

  bool get isLoading => _isLoading;
  String? get message => _message;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final trimmedUsername = username.trim();

    if (trimmedUsername.isEmpty || password.isEmpty) {
      _message = 'Please enter username and password';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      final result = await _apiService.login(trimmedUsername, password);
      _message = result['success'] == true
          ? 'Login successful'
          : (result['message'] as String?) ?? 'Login failed';
    } catch (_) {
      _message = 'Could not connect to server';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessage() {
    _message = null;
  }
}