import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _ownsClient = client == null,
      _baseUrl = baseUrl ?? defaultBaseUrl;

  static const _configuredBaseUrl = String.fromEnvironment('FITNESS_API_URL');

  static String get defaultBaseUrl {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  final http.Client _client;
  final bool _ownsClient;
  final String _baseUrl;

  Future<ApiUser> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final response = await _post('login', {
      'login': usernameOrEmail,
      'password': password,
    });
    return ApiUser.fromResponse(response);
  }

  Future<ApiUser> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _post('sign_up', {
      'name': username,
      'username': username,
      'email': email,
      'password': password,
    });
    return ApiUser.fromResponse(response);
  }

  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, String> body,
  ) async {
    late final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('$_baseUrl/api/$endpoint'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const ApiException('The server took too long to respond.');
    } on http.ClientException {
      throw const ApiException(
        'Could not connect to the fitness API. Check that the server is running.',
      );
    }

    late final Object? decodedResponse;
    try {
      decodedResponse = jsonDecode(response.body);
    } on FormatException {
      throw ApiException(
        'The fitness API returned an invalid response '
        '(HTTP ${response.statusCode}).',
      );
    }

    if (decodedResponse is! Map<String, dynamic>) {
      throw const ApiException('The fitness API returned an invalid response.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = decodedResponse['error'];
      throw ApiException(
        error is String ? error : 'Request failed (${response.statusCode}).',
      );
    }

    return decodedResponse;
  }

  void dispose() {
    if (_ownsClient) _client.close();
  }
}

class ApiUser {
  const ApiUser({required this.username});

  final String username;

  factory ApiUser.fromResponse(Map<String, dynamic> response) {
    final user = response['user'];
    if (user is! Map<String, dynamic> || user['username'] is! String) {
      throw const ApiException(
        'The fitness API response did not include a username.',
      );
    }

    return ApiUser(username: user['username'] as String);
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
