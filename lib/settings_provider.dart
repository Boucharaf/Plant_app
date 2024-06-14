import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDayNight = false;
  double _fontSize = 18.0;
  String _selectedLanguage = 'Français';

  bool get isDayNight => _isDayNight;
  double get fontSize => _fontSize;
  String get selectedLanguage => _selectedLanguage;

  void toggleDayNight(bool value) {
    _isDayNight = value;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}
