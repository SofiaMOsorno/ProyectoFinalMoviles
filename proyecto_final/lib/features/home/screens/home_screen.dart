import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/features/home/screens/join_screen.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isAuthenticated = authService.currentUser != null;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: themeProvider.primaryColor,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: CustomButton(
                          text: isAuthenticated ? 'Create Queue' : 'Start a Queue',
                          borderRadius: 0,
                          backgroundColor: themeProvider.secondaryColor,
                          textStyle: GoogleFonts.ericaOne(
                            color: themeProvider.primaryColor,
                            fontSize: 43,
                          ),
                          onPressed: () {
                            if (isAuthenticated) {
                              Navigator.pushNamed(context, '/create-queue');
                            } else {
                              Navigator.pushNamed(context, '/login');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: themeProvider.backgroundColor,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Join a Queue',
                          borderRadius: 0,
                          backgroundColor: themeProvider.secondaryColor,
                          textStyle: GoogleFonts.ericaOne(
                            color: themeProvider.backgroundColor,
                            fontSize: 43,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JoinScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}