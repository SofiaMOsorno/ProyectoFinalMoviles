import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showCustomModal({
  required BuildContext context,
  required String title,
  required String message,
  required String actionText,
  required VoidCallback onActionPressed,
  String cancelText = 'CANCEL',
  required dynamic themeProvider,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: themeProvider.textField,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.ericaOne(
                color: themeProvider.secondaryColor,
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(
                color: themeProvider.secondaryColor,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 24),

            // Botón principal
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.secondaryColor,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Cierra el modal
                onActionPressed();
              },
              child: Text(
                actionText,
                style: GoogleFonts.ericaOne(
                  color: themeProvider.textPrimary,
                  fontSize: 30,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Botón de cancelar
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
                cancelText,
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
}
