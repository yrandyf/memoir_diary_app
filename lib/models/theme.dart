import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  final String key = "theme";
  SharedPreferences? prefs;
  late bool _darkTheme;

  ThemeChanger() {
    _darkTheme = true;
    loadFromPrefs();
  }
  bool get darkTheme => _darkTheme;

  toggleTheme() {
    _darkTheme = !_darkTheme;
    saveToPrefs();
    notifyListeners();
  }

  loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = prefs!.getBool(key) ?? true;
    notifyListeners();
  }

  saveToPrefs() async {
    await _initPrefs();
    prefs!.setBool(key, darkTheme);
  }

  _initPrefs() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }
}
