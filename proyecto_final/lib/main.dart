import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_final/core/theme/app_theme.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/core/constants/app_routes.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:proyecto_final/services/fcm_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize FCM Service
  final fcmService = FCMService();
  await fcmService.initialize();
  
  runApp(MyApp(fcmService: fcmService));
}

class MyApp extends StatelessWidget {
  final FCMService fcmService;
  
  const MyApp({super.key, required this.fcmService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FCMService>.value(value: fcmService),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Queue Up',
            theme: AppTheme.theme,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.home,
            routes: AppRoutes.getRoutes(),
          );
        },
      ),
    );
  }
}