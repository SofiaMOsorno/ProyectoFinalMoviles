import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Colores dinámicos según el tema
  Color get primaryColor => _isDarkMode ? const Color.fromARGB(255, 1, 1, 61) : const Color(0xFF6B1D5C);
  Color get secondaryColor => _isDarkMode ? const Color.fromARGB(255, 128, 149, 205) : const Color(0xFFFF3366);
  Color get backgroundColor => _isDarkMode ? const Color.fromARGB(255, 33, 33, 79) : const Color(0xFF0A1931);
  
  Color get lightAccent => _isDarkMode ? const Color(0xFF6B7AA1) : const Color(0xFF9B7A95);
  
  Color get textPrimary => _isDarkMode ? const Color.fromARGB(255, 197, 196, 206) :const Color(0xFFFFFFFF);
  Color get textField => _isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFFFFFFF);
  
  Color get border => _isDarkMode ? const Color(0xFF16213E) : const Color(0xFF0A1931);
}