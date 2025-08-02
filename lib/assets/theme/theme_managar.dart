import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static final ThemeManager instance = ThemeManager._internal();
  
  factory ThemeManager() {
    return instance;
  }
  
  ThemeManager._internal();
  
  // Màu sắc cầu vồng
  final List<ColorOption> colorOptions = [
    ColorOption('Red', Colors.red),
    ColorOption('Orange', Colors.orange),
    ColorOption('Yellow', Colors.yellow),
    ColorOption('Green', Colors.green),
    ColorOption('Blue', Colors.blue),
    ColorOption('Indigo', Color(0xFF3F51B5)),
    ColorOption('Violet', Colors.purple),
  ];
  
  final String _colorIndexKey = 'selected_color_index';
  
  int _currentColorIndex = 4;
  
  Color get currentColor => colorOptions[_currentColorIndex].color;
  
  int get currentColorIndex => _currentColorIndex;
  
  ValueNotifier<int> colorNotifier = ValueNotifier<int>(4);
  
  Future<void> init() async {
    await _loadSavedColor();
  }
  
  Future<void> _loadSavedColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentColorIndex = prefs.getInt(_colorIndexKey) ?? 4; // Blue là màu mặc định
    colorNotifier.value = _currentColorIndex;
  }
  
  Future<void> changeColor(int index) async {
    if (index >= 0 && index < colorOptions.length) {
      _currentColorIndex = index;
      colorNotifier.value = index;
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_colorIndexKey, index);
    }
  }
}

class ColorOption {
  final String name;
  final Color color;
  
  ColorOption(this.name, this.color);
}