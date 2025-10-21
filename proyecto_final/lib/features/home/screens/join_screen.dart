import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/features/home/screens/in_queue_screen.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/app_drawer.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          drawer: const AppDrawer(),
          appBar: AppBar(
            backgroundColor: themeProvider.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: themeProvider.textPrimary,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
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
          body: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: themeProvider.textField,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: themeProvider.secondaryColor, width: 10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'JOIN QUEUE',
                          style: GoogleFonts.ericaOne(
                            color: themeProvider.secondaryColor,
                            fontSize: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/mcdonalds_logo.jpg',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "You're going to join McDonald's queue",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                            color: themeProvider.secondaryColor,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProvider.secondaryColor,
                            minimumSize: const Size(double.infinity, 45),
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
                              color: themeProvider.textPrimary,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProvider.backgroundColor,
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.ericaOne(
                              color: themeProvider.textPrimary,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: CustomButton(
                      text: 'JOIN A QUEUE',
                      borderRadius: 0,
                      backgroundColor: themeProvider.secondaryColor,
                      textStyle: GoogleFonts.ericaOne(
                        color: themeProvider.backgroundColor,
                        fontSize: 43,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
      },
    );
  }
}