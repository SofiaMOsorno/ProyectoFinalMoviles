import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_final/core/theme/app_theme.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/core/constants/app_routes.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:proyecto_final/services/fcm_token_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Actualizar token FCM si hay usuario logueado
  final authService = AuthService();
  final fcmTokenService = FCMTokenService();

  if (authService.currentUser != null) {
    await fcmTokenService.saveTokenToFirestore(authService.currentUser!.uid);
    fcmTokenService.setupTokenRefreshListener(authService.currentUser!.uid);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
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