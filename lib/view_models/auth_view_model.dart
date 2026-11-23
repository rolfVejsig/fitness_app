import 'package:flutter/foundation.dart';

import '../services/api_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      _ownsApiService = apiService == null;

  final ApiService _apiService;
  final bool _ownsApiService;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<ApiUser> login({
    required String usernameOrEmail,
    required String password,
  }) {
    return _run(() {
      return _apiService.login(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );
    });
  }

  Future<ApiUser> signUp({
    required String username,
    required String email,
    required String password,
  }) {
    return _run(() {
      return _apiService.signUp(
        username: username,
        email: email,
        password: password,
      );
    });
  }

  Future<ApiUser> _run(Future<ApiUser> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await action();
    } on ApiException catch (error) {
      _errorMessage = error.message;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    if (_ownsApiService) _apiService.dispose();
    super.dispose();
  }
}
