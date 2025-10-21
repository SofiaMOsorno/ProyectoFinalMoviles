import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/custom_text_field.dart';
import 'package:proyecto_final/shared/widgets/app_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryColor,
          drawer: const AppDrawer(),
          appBar: AppBar(
            backgroundColor: themeProvider.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: themeProvider.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: themeProvider.textPrimary),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'WELCOME\nBACK!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ericaOne(
                          color: themeProvider.lightAccent,
                          fontSize: 48,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    height: 100,
                    text: 'Start a Queue',
                    backgroundColor: themeProvider.secondaryColor,
                    textStyle: GoogleFonts.ericaOne(
                      color: themeProvider.primaryColor,
                      fontSize: 43,
                    ),
                    borderRadius: 0,
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      const CustomTextField(
                        label: 'Username',
                      ),
                      const SizedBox(height: 5),
                      const CustomTextField(
                        label: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        text: 'Login',
                        backgroundColor: themeProvider.secondaryColor,
                        textStyle: GoogleFonts.ericaOne(
                          color: themeProvider.textPrimary,
                          fontSize: 28,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login functionality coming soon'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "Don't have an account yet?",
                        style: TextStyle(
                          color: themeProvider.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomButton(
                        text: 'Register',
                        backgroundColor: themeProvider.secondaryColor,
                        textStyle: GoogleFonts.ericaOne(
                          color: themeProvider.textPrimary,
                          fontSize: 28,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}