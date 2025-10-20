import 'package:flutter/material.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Start a Queue',
                height: 100,
                textStyle: GoogleFonts.ericaOne(
                  color: AppColors.primaryPurple,
                  fontSize: 43,
                ),
                borderRadius: 0,
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const CustomTextField(
                    label: 'Create username*',
                  ),
                  const SizedBox(height: 15),
                  const CustomTextField(
                    label: 'Password*',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  const CustomTextField(
                    label: 'Confirm Password*',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  _buildUploadSection(context),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Register',
                    textStyle: GoogleFonts.ericaOne(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                    onPressed: () {
                      // TODO: Implement registration logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration functionality coming soon'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: 'Login',
                    textStyle: GoogleFonts.ericaOne(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
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

  Widget _buildUploadSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload profile pic',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              // TODO: Implement file picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('File picker coming soon'),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.lightPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.upload_file,
                    color: AppColors.darkBlue,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  'Upload a File',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
