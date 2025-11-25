import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/features/home/screens/join_screen.dart';
import 'package:proyecto_final/features/home/screens/in_queue_screen.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:proyecto_final/services/queue_service.dart';
import 'package:proyecto_final/models/queue_model.dart';
import 'package:proyecto_final/models/queue_member_model.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool expandCreate = false;
  bool expandJoin = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final authService = Provider.of<AuthService>(context, listen: false);

    final isAuthenticated = authService.currentUser != null;

    final fullHeight = MediaQuery.of(context).size.height;
    final halfHeight = fullHeight * 0.5;

    return Scaffold(
      body: Column(
        children: [
          // ---------- TOP SECTION (CREATE QUEUE) ----------
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            height: expandCreate
                ? fullHeight
                : expandJoin
                    ? 0
                    : halfHeight,
            width: double.infinity,
            color: themeProvider.primaryColor,
            child: expandJoin
                ? const SizedBox.shrink()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: CustomButton(
                          text: isAuthenticated ? 'Create Queue' : 'Start a Queue',
                          borderRadius: 0,
                          backgroundColor: themeProvider.secondaryColor,
                          textStyle: GoogleFonts.ericaOne(
                            color: themeProvider.primaryColor,
                            fontSize: 43,
                          ),
                          onPressed: () async {
                            setState(() {
                              expandCreate = true;
                            });

                            await Future.delayed(
                                const Duration(milliseconds: 550));

                            if (isAuthenticated) {
                              Navigator.pushNamed(context, '/create-queue');
                            } else {
                              Navigator.pushNamed(context, '/login');
                            }

                            setState(() {
                              expandCreate = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
          ),

          // ---------- BOTTOM SECTION (JOIN QUEUE) ----------
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            height: expandJoin
                ? fullHeight
                : expandCreate
                    ? 0
                    : halfHeight,
            width: double.infinity,
            color: themeProvider.backgroundColor,
            child: expandCreate
                ? const SizedBox.shrink()
                : Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Join a Queue',
                          borderRadius: 0,
                          backgroundColor: themeProvider.secondaryColor,
                          textStyle: GoogleFonts.ericaOne(
                            color: themeProvider.backgroundColor,
                            fontSize: 43,
                          ),
                          onPressed: () async {
                            setState(() {
                              expandJoin = true;
                            });

                            await Future.delayed(
                                const Duration(milliseconds: 550));

                            final currentUser = authService.currentUser;
                            if (currentUser != null) {
                              final queueService = QueueService();
                              try {
                                final activeQueueData = await queueService.getUserActiveQueue(currentUser.uid);

                                if (activeQueueData != null && context.mounted) {
                                  final queue = activeQueueData['queue'] as QueueModel;
                                  final member = activeQueueData['member'] as QueueMemberModel;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => InQueueScreen(
                                        queueId: queue.id,
                                        userId: currentUser.uid,
                                        userName: member.username,
                                      ),
                                    ),
                                  );
                                } else if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const JoinScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const JoinScreen(),
                                    ),
                                  );
                                }
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const JoinScreen(),
                                ),
                              );
                            }

                            setState(() {
                              expandJoin = false;
                            });
                          },
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