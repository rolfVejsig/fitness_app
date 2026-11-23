import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'login sends the API login field and returns the account username',
    () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/login');
        expect(jsonDecode(request.body), {
          'login': 'runner',
          'password': 'secret',
        });
        return http.Response(
          jsonEncode({
            'user': {'username': 'runner'},
          }),
          200,
        );
      });
      addTearDown(client.close);

      final service = ApiService(client: client, baseUrl: 'http://api.test');
      final user = await service.login(
        usernameOrEmail: 'runner',
        password: 'secret',
      );

      expect(user.username, 'runner');
    },
  );

  test(
    'sign up sends username as the API name and surfaces API errors',
    () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/sign_up');
        expect(jsonDecode(request.body), {
          'name': 'runner',
          'username': 'runner',
          'email': 'runner@example.com',
          'password': 'secret',
        });
        return http.Response(
          jsonEncode({'error': 'Username or email already exists'}),
          409,
        );
      });
      addTearDown(client.close);

      final service = ApiService(client: client, baseUrl: 'http://api.test');

      await expectLater(
        service.signUp(
          username: 'runner',
          email: 'runner@example.com',
          password: 'secret',
        ),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            'Username or email already exists',
          ),
        ),
      );
    },
  );
}
