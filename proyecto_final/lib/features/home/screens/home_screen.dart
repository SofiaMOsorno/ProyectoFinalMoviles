import 'package:flutter/material.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/features/home/screens/join_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  padding: const EdgeInsets.only(bottom: 40.0, left: 0, right: 0),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Start a Queue',
                      borderRadius: 0,
                      textStyle: GoogleFonts.ericaOne(
                        color: AppColors.primaryPurple,
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
              color: AppColors.darkBlue,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 0, right: 0),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Join a Queue',
                      borderRadius: 0,
                      textStyle: GoogleFonts.ericaOne(
                        color: AppColors.darkBlue,
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
  }
}