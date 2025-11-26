import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/services/queue_service.dart';
import 'package:proyecto_final/models/queue_member_model.dart';

class InQueueScreen extends StatefulWidget {
  final String queueId;
  final String userId;
  final String? userName;

  const InQueueScreen({
    super.key,
    required this.queueId,
    required this.userId,
    this.userName,
  });

  @override
  State<InQueueScreen> createState() => _InQueueScreenState();
}

class _InQueueScreenState extends State<InQueueScreen> {
  final QueueService _queueService = QueueService();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
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
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: themeProvider.backgroundColor,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<QueueMemberModel>>(
                  stream: _queueService.getQueueMembers(widget.queueId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: themeProvider.secondaryColor,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading queue',
                          style: GoogleFonts.lexendDeca(
                            color: themeProvider.textPrimary,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    final members = snapshot.data ?? [];
                    final userMember = members.firstWhere(
                      (m) => m.userId == widget.userId,
                      orElse: () => QueueMemberModel(
                        id: '',
                        userId: widget.userId,
                        username: widget.userName ?? 'Unknown',
                        position: -1,
                        joinedAt: DateTime.now(),
                      ),
                    );

                    if (userMember.position == -1) {
                      return Center(
                        child: Text(
                          'You are not in the queue',
                          style: GoogleFonts.lexendDeca(
                            color: themeProvider.textPrimary,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    final position = userMember.position + 1;
                    final totalMembers = members.length;
                    final progress = totalMembers > 1 ? (totalMembers - position) / (totalMembers - 1) : 1.0;

                    return Padding(
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
                                        value: progress,
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
                                          '$position',
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
                          _buildLeaveQueueButton(context, themeProvider, userMember),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeaveQueueButton(
    BuildContext context,
    ThemeProvider themeProvider,
    QueueMemberModel userMember,
  ) {
    return Padding(
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
            showModalBottomSheet(
              context: context,
              backgroundColor: themeProvider.textField,
              builder: (BuildContext modalContext) {
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
                        onPressed: () async {
                          try {
                            await _queueService.removeMemberFromQueue(
                              queueId: widget.queueId,
                              memberId: userMember.id,
                            );

                            if (context.mounted) {
                              Navigator.pop(modalContext);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.pop(modalContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error leaving queue: $e')),
                              );
                            }
                          }
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
                          Navigator.pop(modalContext);
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
    );
  }
}