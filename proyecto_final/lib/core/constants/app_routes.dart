import 'package:flutter/material.dart';
import 'package:proyecto_final/features/home/screens/home_screen.dart';
import 'package:proyecto_final/features/auth/screens/login_screen.dart';
import 'package:proyecto_final/features/auth/screens/register_screen.dart';

/// Application route configuration
class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
    };
  }

  AppRoutes._();
}
