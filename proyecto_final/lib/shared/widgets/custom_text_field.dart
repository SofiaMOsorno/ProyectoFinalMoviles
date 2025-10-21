import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    this.label,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style: TextStyle(
                color: themeProvider.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: themeProvider.textField,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: themeProvider.border,
              width: 3,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              fontSize: 18,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}