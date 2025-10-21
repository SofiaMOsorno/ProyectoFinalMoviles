import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/app_theme.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/core/constants/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Virtual Queue App',
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