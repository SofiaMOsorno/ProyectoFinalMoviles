import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';

class QueueQrScreen extends StatelessWidget {
  const QueueQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                children: [
                  _buildHeader(themeProvider),
                  const SizedBox(height: 30),
                  _buildQrSection(themeProvider),
                  const Spacer(),
                  _buildManageButton(context, themeProvider),
                  const SizedBox(height: 16),
                  _buildActionButtons(themeProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: themeProvider.secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "START A QUEUE",
        textAlign: TextAlign.center,
        style: GoogleFonts.ericaOne(
          color: themeProvider.backgroundColor,
          fontSize: 32,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildQrSection(ThemeProvider themeProvider) {
    return Column(
      children: [
        Text(
          'Done! Your users should\ndownload this code to enter\nyour Queue',
          textAlign: TextAlign.center,
          style: GoogleFonts.lexendDeca(
            color: themeProvider.secondaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeProvider.textPrimary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.link,
                size: 80,
                color: themeProvider.backgroundColor,
              ),
            ),
            const SizedBox(width: 30),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeProvider.textPrimary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                'assets/images/mini_qr.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManageButton(BuildContext context, ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.pushNamed(
            context, 
            '/management',
            arguments: 'My Queue', // Nombre hardcodeado por ahora
          );
        },
        child: Text(
          'MANAGE',
          style: GoogleFonts.ericaOne(
            color: themeProvider.textPrimary,
            fontSize: 36,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Download functionality
              },
              child: Icon(
                Icons.download,
                color: themeProvider.textPrimary,
                size: 40,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Share functionality
              },
              child: Text(
                'SHARE',
                style: GoogleFonts.ericaOne(
                  color: themeProvider.textPrimary,
                  fontSize: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}