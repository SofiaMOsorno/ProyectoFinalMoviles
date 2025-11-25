import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/qr_code_widget.dart';

class BigQrScreen extends StatelessWidget {
  final String queueId;

  const BigQrScreen({
    super.key,
    required this.queueId,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final qrSize = screenSize.width * 0.85;

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
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: QrCodeWidget(
                queueId: queueId,
                size: qrSize,
                backgroundColor: themeProvider.backgroundColor,
                foregroundColor: themeProvider.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}