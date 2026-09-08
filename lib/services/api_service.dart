import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl =
      'http://10.142.122.21:3000';

  Future<Map<String, dynamic>> login(
      String username,
      String password,
      ) async {

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }
}