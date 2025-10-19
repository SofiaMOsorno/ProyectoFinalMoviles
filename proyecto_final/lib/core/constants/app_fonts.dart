import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Título principal (Erica One)
  static final TextStyle title = GoogleFonts.ericaOne(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.2,
  );

  // Subtítulo o encabezado secundario (Erica One)
  static final TextStyle subtitle = GoogleFonts.ericaOne(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.1,
  );

  // Texto normal (Lexend Deca)
  static final TextStyle body = GoogleFonts.lexendDeca(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  // Variante más pequeña del body
  static final TextStyle bodySmall = GoogleFonts.lexendDeca(
    fontSize: 12,
  );

  // Texto destacado (por ejemplo números grandes o énfasis)
  static final TextStyle highlight = GoogleFonts.ericaOne(
    fontSize: 80,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );
}
