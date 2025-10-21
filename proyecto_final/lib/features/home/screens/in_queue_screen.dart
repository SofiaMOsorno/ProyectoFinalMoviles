import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/app_drawer.dart';

class InQueueScreen extends StatelessWidget {
  const InQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          drawer: const AppDrawer(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: themeProvider.textPrimary,
                          size: 30,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: themeProvider.secondaryColor,
                        ),
                        child: Text(
                          "YOUR QUEUE",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ericaOne(
                            color: themeProvider.backgroundColor,
                            fontSize: 43,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
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
                              color: themeProvider.textPrimary,
                              fontSize: 40,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 300,
                            width: 300,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 280,
                                  height: 280,
                                  child: CircularProgressIndicator(
                                    value: 0.25,
                                    strokeWidth: 20,
                                    backgroundColor: themeProvider.textPrimary.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      themeProvider.secondaryColor,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '15',
                                      style: GoogleFonts.ericaOne(
                                        color: themeProvider.textPrimary,
                                        fontSize: 120,
                                        height: 1.0,
                                      ),
                                    ),
                                    Text(
                                      'Place',
                                      style: GoogleFonts.ericaOne(
                                        color: themeProvider.textPrimary,
                                        fontSize: 35,
                                      ),
                                    ),
                                  ],
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
                              color: themeProvider.textPrimary,
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
                              backgroundColor: themeProvider.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              //
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
                                          'LEAVE QUEUE?',
                                          style: GoogleFonts.ericaOne(
                                            color: themeProvider.secondaryColor,
                                            fontSize: 40,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Are you sure you want to leave this queue? If you rejoin the queue later you'll enter in last place.",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lexendDeca(
                                            color: themeProvider.secondaryColor,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        
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
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'LEAVE',
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
                            child: Text(
                              'LEAVE QUEUE',
                              style: GoogleFonts.ericaOne(
                                color: themeProvider.textPrimary,
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
      },
    );
  }
}