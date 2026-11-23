import 'package:material_ui/material_ui.dart';

enum AppNavigationDestination {
  home,
  workouts,
  profile;

  IconData get icon => switch (this) {
    AppNavigationDestination.home => Icons.home_rounded,
    AppNavigationDestination.workouts => Icons.fitness_center_rounded,
    AppNavigationDestination.profile => Icons.person_outline_rounded,
  };

  String get label => switch (this) {
    AppNavigationDestination.home => 'Home',
    AppNavigationDestination.workouts => 'Workouts',
    AppNavigationDestination.profile => 'Profile',
  };
}
