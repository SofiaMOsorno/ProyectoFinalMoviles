import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/custom_text_field.dart';
import 'package:proyecto_final/shared/widgets/app_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
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
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Start a Queue',
                    height: 100,
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
                      _buildUploadSection(context, themeProvider),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: 'Register',
                        backgroundColor: themeProvider.secondaryColor,
                        textStyle: GoogleFonts.ericaOne(
                          color: themeProvider.textPrimary,
                          fontSize: 28,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registration functionality coming soon'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: themeProvider.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomButton(
                        text: 'Login',
                        backgroundColor: themeProvider.secondaryColor,
                        textStyle: GoogleFonts.ericaOne(
                          color: themeProvider.textPrimary,
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
      },
    );
  }

  Widget _buildUploadSection(BuildContext context, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload profile pic',
          style: TextStyle(
            color: themeProvider.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 70,
          decoration: BoxDecoration(
            color: themeProvider.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
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
                    color: themeProvider.lightAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.upload_file,
                    color: themeProvider.backgroundColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Upload a File',
                  style: TextStyle(
                    color: themeProvider.textPrimary,
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