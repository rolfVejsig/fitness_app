import 'package:fitness_app/screens/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('creates a routine and retains it across tab changes', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen(username: 'Alex')),
    );

    await tester.tap(find.text('Workouts').last);
    await tester.pumpAndSettle();
    expect(find.text('Workout'), findsOneWidget);
    expect(find.text('Start empty workout'), findsNothing);
    expect(find.text('Explore'), findsNothing);

    await tester.tap(find.text('New routine'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Core');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Core'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Core'), findsOneWidget);
    expect(find.text('4 saved routines'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workouts').last);
    await tester.pumpAndSettle();
    expect(find.text('Core'), findsOneWidget);

    await tester.tap(find.text('Start routine').first);
    await tester.pumpAndSettle();
    expect(find.text('Start workout'), findsOneWidget);
  });
}
