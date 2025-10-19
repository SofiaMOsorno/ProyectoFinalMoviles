import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';

class InQueueScreen extends StatelessWidget {
  const InQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                  ),
                  child: Text(
                    "MCFONALD'S QUEUE",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ericaOne(
                      color: AppColors.darkBlue,
                      fontSize: 50,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'You are in',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.ericaOne(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '15',
                        style: GoogleFonts.ericaOne(
                          color: Colors.white,
                          fontSize: 150,
                        ),
                      ),
                    ),
                    Text(
                      'Place',
                      style: GoogleFonts.ericaOne(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "WE'LL LET YOU KNOW WHEN YOUR TURN IS CLOSE!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You can close this app in the meantime',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    color: Colors.white70,
                    fontSize: 20
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: Size(double.infinity, 65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'LEAVE QUEUE',
                style: GoogleFonts.ericaOne(
                  color: Colors.white,
                  fontSize: 45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
