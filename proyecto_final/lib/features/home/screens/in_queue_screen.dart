import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/services/queue_service.dart';
import 'package:proyecto_final/services/guest_session_service.dart';
import 'package:proyecto_final/models/queue_member_model.dart';
import 'package:proyecto_final/models/queue_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:proyecto_final/services/queue_notification_service.dart';

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
  final QueueNotificationService _notificationService = QueueNotificationService();
  QueueModel? _queueData;
  int? _lastPosition;
  Timer? _uiUpdateTimer;
  final ValueNotifier<int> _timerTick = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _loadQueueData();
    // Start listening to position changes for notifications
    _notificationService.listenToQueuePositionChanges(
      widget.queueId,
      widget.userId,
    );

    // Timer para actualizar solo el contador cada segundo
    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _timerTick.value++;
      }
    });
  }

  @override
  void dispose() {
    _uiUpdateTimer?.cancel();
    _timerTick.dispose();
    super.dispose();
  }

  Future<void> _loadQueueData() async {
    try {
      final queue = await _queueService.getQueue(widget.queueId);
      if (mounted) {
        setState(() {
          _queueData = queue;
        });
      }
    } catch (e) {
      // Handle error silently
    }
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _shareQueueCode(ThemeProvider themeProvider) async {
    await Clipboard.setData(ClipboardData(text: widget.queueId));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Queue code copied to clipboard!',
            style: GoogleFonts.lexendDeca(),
          ),
          backgroundColor: themeProvider.secondaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _launchURL(String url, ThemeProvider themeProvider) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening link: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFollowLinkDialog(ThemeProvider themeProvider, String url) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: themeProvider.textField,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: themeProvider.secondaryColor,
                width: 10,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'FOLLOW LINK?',
                  style: GoogleFonts.ericaOne(
                    color: themeProvider.secondaryColor,
                    fontSize: 36,
                  ),
                ),
                Text(
                  'You will be redirected to the extra media your admin left for you',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    color: themeProvider.secondaryColor,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.secondaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _launchURL(url, themeProvider);
                  },
                  child: Text(
                    'CONTINUE',
                    style: GoogleFonts.ericaOne(
                      color: themeProvider.textPrimary,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.backgroundColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    'CANCEL',
                    style: GoogleFonts.ericaOne(
                      color: themeProvider.textPrimary,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInfoDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeProvider.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: themeProvider.secondaryColor,
              width: 3,
            ),
          ),
          title: Text(
            'Follow Link Button',
            style: GoogleFonts.ericaOne(
              color: themeProvider.secondaryColor,
              fontSize: 22,
            ),
          ),
          content: Text(
            'This button will redirect you to the extra resources. It could be a menu, publicity, a website, or even anything!',
            style: GoogleFonts.lexendDeca(
              color: themeProvider.backgroundColor,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'GOT IT',
                style: GoogleFonts.ericaOne(
                  color: themeProvider.secondaryColor,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
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

                    // Check if position changed to 0 or 1 and send notification
                    _checkPositionChange(userMember.position);

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
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 250,
                                width: 250,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 230,
                                      height: 230,
                                      child: CircularProgressIndicator(
                                        value: progress,
                                        strokeWidth: 18,
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
                                            fontSize: 100,
                                            height: 1.0,
                                          ),
                                        ),
                                        Text(
                                          'Place',
                                          style: GoogleFonts.ericaOne(
                                            color: themeProvider.textPrimary,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '${_queueData?.title ?? 'Your'} queue',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ericaOne(
                                  color: themeProvider.secondaryColor,
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                position == 1
                                    ? "IT'S YOUR TURN!\nGO BEFORE THE TIME RUNS OUT!"
                                    : "WE'LL LET YOU KNOW WHEN\nYOUR TURN IS CLOSE!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lexendDeca(
                                  color: themeProvider.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              // Mostrar contador de timeout solo si está en posición 1
                              if (position == 1 && _queueData != null)
                                ValueListenableBuilder<int>(
                                  valueListenable: _timerTick,
                                  builder: (context, tick, child) {
                                    return _buildTimeoutCounter(
                                      themeProvider,
                                      userMember,
                                      _queueData!.timerSeconds,
                                    );
                                  },
                                ),
                              const SizedBox(height: 20),
                              // Botón para compartir código
                              _buildShareCodeButton(themeProvider),
                            ],
                          ),
                          Column(
                            children: [
                              // Sección de enlace extra (solo si existe)
                              if (_queueData?.fileUrl != null && _queueData!.fileUrl!.isNotEmpty)
                                _buildExtraLinkSection(themeProvider),
                              const SizedBox(height: 16),
                              _buildLeaveQueueButton(context, themeProvider, userMember),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _checkPositionChange(int currentPosition) {
    // Solo notificar si la posición cambió y es 0 o 1
    if (_lastPosition != null && _lastPosition != currentPosition) {
      if (currentPosition == 0 || currentPosition == 1) {
        // Usar Future.delayed para evitar múltiples notificaciones
        Future.delayed(const Duration(milliseconds: 500), () {
          _notificationService.checkAndNotifyPosition(
            widget.queueId,
            widget.userId,
          );
        });
      }
    }
    _lastPosition = currentPosition;
  }

  Widget _buildTimeoutCounter(
    ThemeProvider themeProvider,
    QueueMemberModel member,
    int timerSeconds,
  ) {
    final remainingSeconds = _calculateRemainingSeconds(member, timerSeconds);
    final isPresent = member.timeoutStartedAt == null;
    final isExpired = !isPresent && remainingSeconds == 0;

    // Determinar el color basándose en el estado
    Color backgroundColor;
    Color textColor;
    String statusText;

    if (isExpired) {
      // Tiempo expirado - rojo
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
      statusText = 'KICKED FOR INACTIVITY';
    } else if (isPresent) {
      // Usuario presente - verde
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
      statusText = 'YOU\'RE ALL SET!';
    } else {
      // Contando - naranja/ámbar
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade900;
      statusText = 'TIME TO REPORT: ${_formatTime(remainingSeconds)}';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: textColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(
          statusText,
          textAlign: TextAlign.center,
          style: GoogleFonts.lexendDeca(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildShareCodeButton(ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.secondaryColor.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: themeProvider.secondaryColor,
              width: 2,
            ),
          ),
          elevation: 0,
        ),
        icon: Icon(
          Icons.share,
          color: themeProvider.secondaryColor,
          size: 24,
        ),
        label: Text(
          'SHARE CODE',
          style: GoogleFonts.ericaOne(
            color: themeProvider.secondaryColor,
            fontSize: 22,
          ),
        ),
        onPressed: () => _shareQueueCode(themeProvider),
      ),
    );
  }

  Widget _buildExtraLinkSection(ThemeProvider themeProvider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'The admin has left this extra media for you',
                textAlign: TextAlign.center,
                style: GoogleFonts.lexendDeca(
                  color: themeProvider.secondaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showInfoDialog(themeProvider),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: themeProvider.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: themeProvider.textPrimary,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            icon: Icon(
              Icons.link,
              color: themeProvider.textPrimary,
              size: 24,
            ),
            label: Text(
              'FOLLOW LINK',
              style: GoogleFonts.ericaOne(
                color: themeProvider.textPrimary,
                fontSize: 24,
              ),
            ),
            onPressed: () => _showFollowLinkDialog(themeProvider, _queueData!.fileUrl!),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveQueueButton(
    BuildContext context,
    ThemeProvider themeProvider,
    QueueMemberModel userMember,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        height: 65,
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

                            if (widget.userId.startsWith('guest_')) {
                              final guestSessionService = GuestSessionService();
                              await guestSessionService.clearGuestSession();
                            }

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
              fontSize: 32,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}