import 'package:flutter/foundation.dart';

import '../models/app_navigation_destination.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.username});

  final String username;

  AppNavigationDestination _selectedDestination = AppNavigationDestination.home;

  AppNavigationDestination get selectedDestination => _selectedDestination;

  void selectDestination(AppNavigationDestination destination) {
    if (_selectedDestination == destination) return;
    _selectedDestination = destination;
    notifyListeners();
  }
}
