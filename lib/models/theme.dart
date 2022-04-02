import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData? _themeDate;
  ThemeChanger(this._themeDate);

  getTheme() => _themeDate;

  setTheme(ThemeData theme) {
    _themeDate = theme;
    notifyListeners();
  }
}
