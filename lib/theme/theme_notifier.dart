import 'package:flutter/material.dart';
import 'package:todo_app/theme/theme_repository.dart';

class ThemeNotifier extends ChangeNotifier {
  final ThemeRepository _repository = ThemeRepository();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _repository.saveDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    _isDarkMode = await _repository.readDarkMode();
    notifyListeners();
  }
}
