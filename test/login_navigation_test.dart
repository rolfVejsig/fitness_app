import 'dart:convert';

import 'package:fitness_app/screens/login_screen.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/view_models/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('login sends credentials and opens the dashboard as the user', (
    tester,
  ) async {
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
    final viewModel = AuthViewModel(
      apiService: ApiService(client: client, baseUrl: 'http://api.test'),
    );
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(viewModel: viewModel)),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'runner');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('runner'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Home' &&
            widget.properties.selected == true,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Workouts' &&
            widget.properties.selected == true,
      ),
      findsNothing,
    );

    await tester.tap(find.byTooltip('Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Username or email'), findsOneWidget);
    expect(find.text('Activity'), findsNothing);
  });

  testWidgets('sign up creates an account and returns to login', (
    tester,
  ) async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/sign_up');
      expect(jsonDecode(request.body), {
        'name': 'runner',
        'username': 'runner',
        'email': 'runner@example.com',
        'password': 'secret',
      });
      return http.Response(
        jsonEncode({
          'user': {'username': 'runner'},
        }),
        201,
      );
    });
    addTearDown(client.close);
    final viewModel = AuthViewModel(
      apiService: ApiService(client: client, baseUrl: 'http://api.test'),
    );
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(viewModel: viewModel)),
    );

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'runner');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'runner@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'secret');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Account created. You can now log in.'), findsOneWidget);
    expect(find.text('runner'), findsOneWidget);
    expect(find.text('Username or email'), findsOneWidget);
  });
}
