import 'package:flutter/material.dart';
import 'package:proyecto_final/features/home/screens/home_screen.dart';
import 'package:proyecto_final/features/auth/screens/login_screen.dart';
import 'package:proyecto_final/features/auth/screens/register_screen.dart';
import 'package:proyecto_final/features/home/screens/join_screen.dart';
import 'package:proyecto_final/features/queue/screens/created_queues_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String join = '/join';
  static const String createdQueues = '/created-queues';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      join: (context) => const JoinScreen(),
      createdQueues: (context) => const CreatedQueuesScreen(),
    };
  }

  AppRoutes._();
}
