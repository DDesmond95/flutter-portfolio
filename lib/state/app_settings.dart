import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  static const _kThemeKey = 'themeMode';
  static const _kReducedMotionKey = 'reducedMotion';

  ThemeMode _themeMode = ThemeMode.system;
  bool _reducedMotion = false;

  ThemeMode get themeMode => _themeMode;
  bool get reducedMotion => _reducedMotion;

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final themeIndex = sp.getInt(_kThemeKey);
    if (themeIndex != null &&
        themeIndex >= 0 &&
        themeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[themeIndex];
    }
    _reducedMotion = sp.getBool(_kReducedMotionKey) ?? false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kThemeKey, mode.index);
  }

  Future<void> setReducedMotion(bool value) async {
    _reducedMotion = value;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kReducedMotionKey, value);
  }
}
