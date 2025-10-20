import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';

class InQueueScreen extends StatelessWidget {
  const InQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 0, right: 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
              ),
              child: Text(
                "YOUR QUEUE",
                textAlign: TextAlign.center,
                style: GoogleFonts.ericaOne(
                  color: AppColors.darkBlue,
                  fontSize: 43,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'You are in',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ericaOne(
                          color: AppColors.textWhite,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: -100,
                              top: 0,
                              child: Container(
                                width: 150,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed,
                                ),
                              )
                            ),
                            Positioned(
                              left: -90,
                              top: 0,
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              left: -10,
                              top: 55,
                                child: Text(
                                  '15',
                                  style: GoogleFonts.ericaOne(
                                    color: AppColors.textWhite,
                                    fontSize: 180,
                                    height: 1.0,
                                  ),
                                ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: -10,
                              child: Text(
                                'Place...',
                                style: GoogleFonts.ericaOne(
                                  color: AppColors.textWhite,
                                  fontSize: 45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      Text(
                        "WE'LL LET YOU KNOW WHEN\nYOUR TURN IS CLOSE!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexendDeca(
                          color: AppColors.textWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You can close this app in the meantime',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexendDeca(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'LEAVE QUEUE',
                          style: GoogleFonts.ericaOne(
                            color: AppColors.textWhite,
                            fontSize: 40,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}