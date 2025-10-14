import 'package:flutter/material.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/custom_text_field.dart';

/// Login screen for users who want to start a queue
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
            // Content with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Welcome message
                  const Text(
                    'WELCOME\nBACK!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.lightPurple,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            // Start a Queue header (full width, no padding)
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Start a Queue',
                borderRadius: 0,
                onPressed: () {},
              ),
            ),
            // Rest of content with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  // Username field
                  const CustomTextField(
                    label: 'Username',
                  ),
                  const SizedBox(height: 5),
                  // Password field
                  const CustomTextField(
                    label: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  // Login button
                  CustomButton(
                    text: 'Login',
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
                  // Don't have an account text
                  const Text(
                    "Don't have an account yet?",
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Register button
                  CustomButton(
                    text: 'Register',
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
