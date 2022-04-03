import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  final String key = "theme";
  SharedPreferences? prefs;
  late bool _darkTheme;

  ThemeChanger() {
    _darkTheme = true;
    loadPrefs();
  }

  bool get darkTheme => _darkTheme;

  toggleTheme() {
    _darkTheme = !_darkTheme;
    savePrefs();
    notifyListeners();
  }

  loadPrefs() async {
    await initPrefs();
    _darkTheme = prefs!.getBool(key) ?? true;
    notifyListeners();
  }

  savePrefs() async {
    await initPrefs();
    prefs!.setBool(key, darkTheme);
  }

  initPrefs() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }
}
