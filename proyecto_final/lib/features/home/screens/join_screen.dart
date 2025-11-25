import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/features/home/screens/in_queue_screen.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:proyecto_final/services/queue_service.dart';
import 'package:proyecto_final/models/queue_model.dart';
import 'package:proyecto_final/models/queue_member_model.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;
  String? _clipboardQueueId;
  bool _showClipboardBanner = false;

  @override
  void initState() {
    super.initState();
    _checkClipboard();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _checkClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final text = clipboardData?.text?.trim();

      if (text != null && text.isNotEmpty && text.length > 10) {
        final queueService = QueueService();
        final queue = await queueService.getQueue(text);

        if (queue != null && queue.isActive && mounted) {
          setState(() {
            _clipboardQueueId = text;
            _showClipboardBanner = true;
          });
        }
      }
    } catch (e) {
      // Clipboard doesn't contain a valid queue ID, ignore
    }
  }

  void _onQRCodeDetected(BarcodeCapture capture, BuildContext context) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? queueId = barcodes.first.rawValue;
    if (queueId == null || queueId.isEmpty) return;

    setState(() => _isProcessing = true);

    cameraController.stop();

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final queueService = QueueService();

    try {
      final queue = await queueService.getQueue(queueId);

      if (queue == null) {
        if (mounted) {
          _showErrorDialog(context, themeProvider, 'Queue not found');
        }
        return;
      }

      if (!queue.isActive) {
        if (mounted) {
          _showErrorDialog(context, themeProvider, 'This queue is no longer active');
        }
        return;
      }

      if (mounted) {
        _showQueueConfirmationDialog(context, themeProvider, authService, queueService, queue);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, themeProvider, 'Error loading queue: $e');
      }
    }
  }

  void _showQueueConfirmationDialog(
    BuildContext context,
    ThemeProvider themeProvider,
    AuthService authService,
    QueueService queueService,
    QueueModel queue,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                Text(
                  queue.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ericaOne(
                    color: themeProvider.secondaryColor,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  queue.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    color: themeProvider.secondaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                StreamBuilder<List<QueueMemberModel>>(
                  stream: queueService.getQueueMembers(queue.id),
                  builder: (context, memberSnapshot) {
                    final realCount = memberSnapshot.data?.length ?? queue.currentCount;
                    return Text(
                      'People in queue: $realCount/${queue.maxPeople}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendDeca(
                        color: themeProvider.secondaryColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    );
                  },
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
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    final currentUser = authService.currentUser;

                    if (currentUser != null) {
                      final userName = currentUser.displayName ??
                          currentUser.email?.split('@')[0] ??
                          'User';

                      try {
                        await queueService.addMemberToQueue(
                          queueId: queue.id,
                          userId: currentUser.uid,
                          username: userName,
                        );

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InQueueScreen(
                                queueId: queue.id,
                                userId: currentUser.uid,
                                userName: userName,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error joining queue: $e')),
                          );
                          setState(() => _isProcessing = false);
                          cameraController.start();
                        }
                      }
                    } else {
                      _showNameInputDialog(context, themeProvider, queueService, queue);
                    }
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
                    Navigator.pop(dialogContext);
                    setState(() => _isProcessing = false);
                    cameraController.start();
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
          ),
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
  }

  Future<void> _joinFromClipboard() async {
    if (_clipboardQueueId == null) return;

    setState(() => _isProcessing = true);
    cameraController.stop();

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final queueService = QueueService();

    try {
      final queue = await queueService.getQueue(_clipboardQueueId!);

      if (queue == null) {
        if (mounted) {
          _showErrorDialog(context, themeProvider, 'Queue not found');
        }
        return;
      }

      if (!queue.isActive) {
        if (mounted) {
          _showErrorDialog(context, themeProvider, 'This queue is no longer active');
        }
        return;
      }

      if (mounted) {
        setState(() => _showClipboardBanner = false);
        _showQueueConfirmationDialog(context, themeProvider, authService, queueService, queue);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, themeProvider, 'Error loading queue: $e');
      }
    }
  }

  void _showErrorDialog(BuildContext context, ThemeProvider themeProvider, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: themeProvider.textField,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Error',
            style: GoogleFonts.ericaOne(color: themeProvider.secondaryColor),
          ),
          content: Text(
            message,
            style: GoogleFonts.lexendDeca(color: themeProvider.secondaryColor),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.secondaryColor,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() => _isProcessing = false);
                cameraController.start();
              },
              child: Text(
                'OK',
                style: GoogleFonts.ericaOne(color: themeProvider.textPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNameInputDialog(
    BuildContext context,
    ThemeProvider themeProvider,
    QueueService queueService,
    QueueModel queue,
  ) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
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
              border: Border.all(color: themeProvider.secondaryColor, width: 10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How should we call you?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ericaOne(
                    color: themeProvider.secondaryColor,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This name will only be visible to the business owner',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    color: themeProvider.secondaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  style: GoogleFonts.lexendDeca(
                    color: themeProvider.secondaryColor,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your first name',
                    hintStyle: GoogleFonts.lexendDeca(
                      color: themeProvider.secondaryColor.withOpacity(0.5),
                      fontSize: 18,
                    ),
                    filled: true,
                    fillColor: themeProvider.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
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
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      Navigator.pop(dialogContext);

                      final guestUserId = 'guest_${DateTime.now().millisecondsSinceEpoch}';

                      try {
                        await queueService.addMemberToQueue(
                          queueId: queue.id,
                          userId: guestUserId,
                          username: name,
                        );

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InQueueScreen(
                                queueId: queue.id,
                                userId: guestUserId,
                                userName: name,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error joining queue: $e')),
                          );
                          setState(() => _isProcessing = false);
                          cameraController.start();
                        }
                      }
                    }
                  },
                  child: Text(
                    'CONTINUE',
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
                    Navigator.pop(dialogContext);
                    setState(() => _isProcessing = false);
                    cameraController.start();
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
          ),
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
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
          ),
          body: Column(
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
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: (capture) => _onQRCodeDetected(capture, context),
                    ),
                    Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: themeProvider.secondaryColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (_showClipboardBanner)
                      Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: themeProvider.secondaryColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.content_paste,
                                  color: themeProvider.backgroundColor,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Queue detected in clipboard',
                                        style: GoogleFonts.lexendDeca(
                                          color: themeProvider.backgroundColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Tap to join',
                                        style: GoogleFonts.lexendDeca(
                                          color: themeProvider.backgroundColor.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: themeProvider.backgroundColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => _showClipboardBanner = false);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (_showClipboardBanner)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: _joinFromClipboard,
                          behavior: HitTestBehavior.translucent,
                        ),
                      ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Align QR code within the frame',
                            style: GoogleFonts.lexendDeca(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
