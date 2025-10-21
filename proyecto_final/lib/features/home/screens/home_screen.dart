import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/app_drawer.dart';
import 'package:proyecto_final/features/home/screens/join_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(
            backgroundColor: themeProvider.primaryColor,
            elevation: 0,
            iconTheme: IconThemeData(color: themeProvider.textPrimary),
          ),
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
                          text: 'Start a Queue',
                          borderRadius: 0,
                          backgroundColor: themeProvider.secondaryColor,
                          textStyle: GoogleFonts.ericaOne(
                            color: themeProvider.primaryColor,
                            fontSize: 43,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
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