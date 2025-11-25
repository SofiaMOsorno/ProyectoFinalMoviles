import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  final String queueId;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const QrCodeWidget({
    super.key,
    required this.queueId,
    this.size = 200,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: queueId,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor ?? Colors.white,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: foregroundColor ?? Colors.black,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foregroundColor ?? Colors.black,
      ),
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );
  }
}
