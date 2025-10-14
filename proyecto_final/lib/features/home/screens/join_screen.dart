import 'package:flutter/material.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textWhite,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Title section with button styling
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 0, right: 0),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'JOIN A QUEUE',
                borderRadius: 0,
                onPressed: () {
                  // TODO: Implement camera functionality
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Camera image section - fills remaining space
          Expanded(
            child: Image.asset(
              'assets/images/camara.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}