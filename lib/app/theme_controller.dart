import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppPalette {
  metal,
  earth,
  wood,
  fire,
  water,
  yin,
  yang,
  abyss,
  lunar,
  storm,
  natural,
  minimal,
  mono,
}

class ThemeController extends ChangeNotifier {
  static const _kModeKey = 'theme.mode';
  static const _kPaletteKey = 'theme.palette';

  ThemeMode _mode = ThemeMode.system;
  AppPalette _palette = AppPalette.wood;

  ThemeMode get mode => _mode;
  AppPalette get palette => _palette;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    switch (p.getString(_kModeKey)) {
      case 'light':
        _mode = ThemeMode.light;
        break;
      case 'dark':
        _mode = ThemeMode.dark;
        break;
      default:
        _mode = ThemeMode.system;
    }
    switch (p.getString(_kPaletteKey)) {
      case 'earth':
        _palette = AppPalette.earth;
        break;
      case 'wood':
        _palette = AppPalette.wood;
        break;
      case 'fire':
        _palette = AppPalette.fire;
        break;
      case 'water':
        _palette = AppPalette.water;
        break;
      case 'yin':
        _palette = AppPalette.yin;
        break;
      case 'yang':
        _palette = AppPalette.yang;
        break;
      case 'abyss':
        _palette = AppPalette.abyss;
        break;
      case 'lunar':
        _palette = AppPalette.lunar;
        break;
      case 'storm':
        _palette = AppPalette.storm;
        break;
      case 'natural':
        _palette = AppPalette.natural;
        break;
      case 'minimal':
        _palette = AppPalette.minimal;
        break;
      case 'mono':
        _palette = AppPalette.mono;
        break;
      default:
        _palette = AppPalette.metal;
    }

    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kModeKey, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    });
    notifyListeners();
  }

  Future<void> setPalette(AppPalette palette) async {
    _palette = palette;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kPaletteKey, switch (palette) {
      AppPalette.earth => 'earth',
      AppPalette.wood => 'wood',
      AppPalette.fire => 'fire',
      AppPalette.water => 'water',
      AppPalette.yin => 'yin',
      AppPalette.yang => 'yang',
      AppPalette.abyss => 'abyss',
      AppPalette.lunar => 'lunar',
      AppPalette.storm => 'storm',
      AppPalette.natural => 'natural',
      AppPalette.minimal => 'minimal',
      AppPalette.mono => 'mono',
      _ => 'metal',
    });

    notifyListeners();
  }
}
