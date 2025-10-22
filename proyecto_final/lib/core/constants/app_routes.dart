import 'package:flutter/material.dart';
import 'package:proyecto_final/features/home/screens/home_screen.dart';
import 'package:proyecto_final/features/auth/screens/login_screen.dart';
import 'package:proyecto_final/features/auth/screens/register_screen.dart';
import 'package:proyecto_final/features/home/screens/join_screen.dart';
import 'package:proyecto_final/features/queue/screens/created_queues_screen.dart';
import 'package:proyecto_final/features/queue/screens/create_queue_screen.dart';
import 'package:proyecto_final/features/queue/screens/queue_qr_screen.dart';
import 'package:proyecto_final/features/queue/screens/management_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String join = '/join';
  static const String createdQueues = '/created-queues';
  static const String createQueue = '/create-queue';
  static const String queueQr = '/queue-qr';
  static const String management = '/management';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      join: (context) => const JoinScreen(),
      createdQueues: (context) => const CreatedQueuesScreen(),
      createQueue: (context) => const CreateQueueScreen(),
      queueQr: (context) => const QueueQrScreen(),
      management: (context) {
        final queueName = ModalRoute.of(context)!.settings.arguments as String? ?? 'My Queue';
        return ManagementScreen(queueName: queueName);
      },
    };
  }

  AppRoutes._();
}