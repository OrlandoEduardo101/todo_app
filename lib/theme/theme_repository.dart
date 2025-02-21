import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  final String _key = 'darkMode';

  Future<bool> readDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isDarkSave = prefs.getBool(_key);
    if (isDarkSave != null) {
      return isDarkSave;
    }
    return false;
  }

  Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);
  }
}
