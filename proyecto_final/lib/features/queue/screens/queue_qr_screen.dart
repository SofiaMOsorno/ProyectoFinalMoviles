import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/qr_code_widget.dart';
import 'package:proyecto_final/features/queue/screens/big_qr_screen.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

class QueueQrScreen extends StatefulWidget {
  final String queueId;

  const QueueQrScreen({
    super.key,
    required this.queueId,
  });

  @override
  State<QueueQrScreen> createState() => _QueueQrScreenState();
}

class _QueueQrScreenState extends State<QueueQrScreen> {
  final GlobalKey _qrKey = GlobalKey();

  Future<void> _downloadQrCode(BuildContext context) async {
    try {
      // Request storage permission
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission is required to save the QR code'),
            ),
          );
        }
        return;
      }

      // Capture the QR code as image
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save to gallery
      await Gal.putImageBytes(pngBytes, album: 'QueueUp');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'QR code saved to gallery!',
              style: GoogleFonts.lexendDeca(),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving QR code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: Column(
            children: [
              _buildHeader(context, themeProvider),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _buildQrSection(context, themeProvider),
                      const Spacer(),
                      _buildManageButton(context, themeProvider),
                      const SizedBox(height: 16),
                      _buildActionButtons(themeProvider),
                      const SizedBox(height: 30),
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

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
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
                fontSize: 32,
                height: 1.0,
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
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                '/created-queues',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrSection(BuildContext context, ThemeProvider themeProvider) {
    return Column(
      children: [
        Text(
          'Done! Your users should\ndownload this code to enter\nyour Queue',
          textAlign: TextAlign.center,
          style: GoogleFonts.lexendDeca(
            color: themeProvider.secondaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: widget.queueId));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Queue ID copied to clipboard!',
                        style: GoogleFonts.lexendDeca(),
                      ),
                      backgroundColor: themeProvider.secondaryColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Icon(
                Icons.link,
                size: 120,
                color: themeProvider.textPrimary,
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BigQrScreen(queueId: widget.queueId),
                  ),
                );
              },
              child: RepaintBoundary(
                key: _qrKey,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: QrCodeWidget(
                    queueId: widget.queueId,
                    size: 104,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManageButton(BuildContext context, ThemeProvider themeProvider) {
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
          Navigator.pushNamed(
            context,
            '/management',
            arguments: {
              'queueName': 'My Queue',
              'queueId': widget.queueId,
            },
          );
        },
        child: Text(
          'MANAGE',
          style: GoogleFonts.ericaOne(
            color: themeProvider.textPrimary,
            fontSize: 36,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeProvider themeProvider) {
    return Builder(
      builder: (context) => Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed: () => _downloadQrCode(context),
                child: Icon(
                  Icons.download,
                  color: themeProvider.textPrimary,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad de compartir proximamente'),
                    ),
                  );
                },
                child: Text(
                  'SHARE',
                  style: GoogleFonts.ericaOne(
                    color: themeProvider.textPrimary,
                    fontSize: 28,
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