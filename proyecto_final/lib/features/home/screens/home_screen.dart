import 'package:flutter/material.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';

/// Home screen with options to start or join a queue
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColors.primaryPurple,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: CustomButton(
                    text: 'Start a Queue',
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.darkBlue,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CustomButton(
                    text: 'Join a Queue',
                    onPressed: () {
                      // TODO: Navigate to join queue screen
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
