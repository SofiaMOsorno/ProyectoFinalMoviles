import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';
import 'package:proyecto_final/features/home/screens/in_queue_screen.dart';
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
      body: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent, width: 10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'JOIN QUEUE',
                      style: GoogleFonts.ericaOne(
                        textStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/mcdonalds_logo.jpg',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    SizedBox(height: 12,),
                    Text(
                      "You're going to join McDonald's queue",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendDeca(
                        textStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InQueueScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'JOIN',
                        style: GoogleFonts.ericaOne(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        minimumSize: Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.ericaOne(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        },
        child: Column(
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
      ),
    );
  }
}