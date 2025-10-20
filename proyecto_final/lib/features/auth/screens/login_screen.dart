import 'package:flutter/material.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
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
                      color: AppColors.lightPurple,
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
                textStyle: GoogleFonts.ericaOne(
                  color: AppColors.primaryPurple,
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
                    textStyle: GoogleFonts.ericaOne(
                      color: AppColors.textWhite,
                      fontSize: 28,
                    ),
                    onPressed: () {
                      // TODO: Implement login logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login functionality coming soon'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Don't have an account yet?",
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: 'Register',
                    textStyle: GoogleFonts.ericaOne(
                      color: AppColors.textWhite,
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
  }
}
