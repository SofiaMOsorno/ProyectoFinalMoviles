import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/services/queue_service.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:proyecto_final/services/queue_timeout_service.dart';
import 'package:proyecto_final/models/queue_member_model.dart';
import 'package:proyecto_final/models/queue_model.dart';
import 'package:proyecto_final/features/queue/screens/management_screen.dart';

class QuickManageScreen extends StatefulWidget {
  final String queueId;
  final String queueName;

  const QuickManageScreen({
    super.key,
    required this.queueId,
    required this.queueName,
  });

  @override
  State<QuickManageScreen> createState() => _QuickManageScreenState();
}

class _QuickManageScreenState extends State<QuickManageScreen> {
  final QueueService _queueService = QueueService();
  final QueueTimeoutService _timeoutService = QueueTimeoutService();
  Timer? _uiUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Iniciar el monitoreo de timeouts para esta fila
    _timeoutService.startMonitoring(widget.queueId);

    // Timer para actualizar la UI cada segundo
    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _uiUpdateTimer?.cancel();
    _timeoutService.stopMonitoring(widget.queueId);
    super.dispose();
  }

  int _calculateRemainingSeconds(QueueMemberModel member, int timerSeconds) {
    if (member.timeoutStartedAt == null) {
      return timerSeconds;
    }

    final now = DateTime.now();
    final elapsedSeconds = now.difference(member.timeoutStartedAt!).inSeconds;
    final remaining = timerSeconds - elapsedSeconds;

    return remaining > 0 ? remaining : 0;
  }

  Future<void> _removeCurrentUser(String memberId, {bool isTimeout = false}) async {
    try {
      await _queueService.removeMemberFromQueue(
        queueId: widget.queueId,
        memberId: memberId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isTimeout ? 'User removed (timeout)' : 'User completed',
              style: GoogleFonts.lexendDeca(),
            ),
            backgroundColor: isTimeout ? Colors.red : Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
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
            title: Text(
              'QUICK MANAGE',
              style: GoogleFonts.ericaOne(
                color: themeProvider.textPrimary,
                fontSize: 24,
              ),
            ),
          ),
          body: StreamBuilder<QueueModel?>(
            stream: _queueService.getQueueStream(widget.queueId),
            builder: (context, queueSnapshot) {
              if (!queueSnapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: themeProvider.secondaryColor,
                  ),
                );
              }

              final queue = queueSnapshot.data!;

              return StreamBuilder<List<QueueMemberModel>>(
                stream: _queueService.getQueueMembers(widget.queueId),
                builder: (context, membersSnapshot) {
                  if (!membersSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: themeProvider.secondaryColor,
                      ),
                    );
                  }

                  final members = membersSnapshot.data!;

                  if (members.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 80,
                            color: themeProvider.secondaryColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No users in queue',
                            style: GoogleFonts.lexendDeca(
                              color: themeProvider.secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 40),
                          _buildFullManageButton(themeProvider),
                        ],
                      ),
                    );
                  }

                  final firstMember = members.first;
                  final remainingSeconds = _calculateRemainingSeconds(firstMember, queue.timerSeconds);
                  final isTimerActive = firstMember.timeoutStartedAt != null;

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CURRENT USER',
                                style: GoogleFonts.ericaOne(
                                  color: themeProvider.secondaryColor.withOpacity(0.7),
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 30,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: themeProvider.textField,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: themeProvider.secondaryColor,
                                    width: 3,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildProfilePicture(
                                      firstMember.userId,
                                      firstMember.username,
                                      themeProvider,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      firstMember.username,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.ericaOne(
                                        color: themeProvider.secondaryColor,
                                        fontSize: 36,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCompleteButton(
                                      themeProvider,
                                      firstMember.id,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildTimeoutButton(
                                      themeProvider,
                                      firstMember.id,
                                      remainingSeconds,
                                      isTimerActive,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'People waiting: ${members.length - 1}',
                                style: GoogleFonts.lexendDeca(
                                  color: themeProvider.secondaryColor.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildFullManageButton(themeProvider),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCompleteButton(ThemeProvider themeProvider, String memberId) {
    return SizedBox(
      height: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
        onPressed: () => _removeCurrentUser(memberId),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              'COMPLETE',
              style: GoogleFonts.ericaOne(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeoutButton(
    ThemeProvider themeProvider,
    String memberId,
    int remainingSeconds,
    bool isTimerActive,
  ) {
    return SizedBox(
      height: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isTimerActive ? Colors.red : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
        onPressed: isTimerActive ? () => _removeCurrentUser(memberId, isTimeout: true) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(remainingSeconds),
              style: GoogleFonts.ericaOne(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'NO SHOW',
              style: GoogleFonts.ericaOne(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullManageButton(ThemeProvider themeProvider) {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ManagementScreen(
                queueName: widget.queueName,
                queueId: widget.queueId,
              ),
            ),
          );
        },
        child: Text(
          'MANAGE & REORDER',
          style: GoogleFonts.ericaOne(
            color: themeProvider.textPrimary,
            fontSize: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(
    String userId,
    String username,
    ThemeProvider themeProvider,
  ) {
    if (userId.startsWith('guest_')) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: themeProvider.secondaryColor.withOpacity(0.2),
        child: Icon(
          Icons.person,
          size: 60,
          color: themeProvider.secondaryColor,
        ),
      );
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: AuthService().getUserData(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return CircleAvatar(
            radius: 50,
            backgroundColor: themeProvider.secondaryColor.withOpacity(0.2),
            child: Text(
              username.isNotEmpty ? username[0].toUpperCase() : '?',
              style: GoogleFonts.ericaOne(
                color: themeProvider.secondaryColor,
                fontSize: 48,
              ),
            ),
          );
        }

        final userData = snapshot.data!;
        final profilePicture = userData['profilePicture'] as String?;

        ImageProvider? imageProvider;
        if (profilePicture != null) {
          if (profilePicture.startsWith('assets/')) {
            imageProvider = AssetImage(profilePicture);
          } else if (profilePicture.startsWith('http')) {
            imageProvider = NetworkImage(profilePicture);
          }
        }

        return CircleAvatar(
          radius: 50,
          backgroundColor: themeProvider.secondaryColor.withOpacity(0.2),
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style: GoogleFonts.ericaOne(
                    color: themeProvider.secondaryColor,
                    fontSize: 48,
                  ),
                )
              : null,
        );
      },
    );
  }
}
