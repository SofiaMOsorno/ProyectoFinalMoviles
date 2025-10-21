import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Drawer(
          backgroundColor: themeProvider.primaryColor,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: themeProvider.secondaryColor,
                ),
                child: Center(
                  child: Text(
                    'MENU',
                    style: GoogleFonts.ericaOne(
                      color: themeProvider.textPrimary,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                      context,
                      themeProvider,
                      'Opcion 1',
                      Icons.settings,
                      () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opcion 1 seleccionada')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      themeProvider,
                      'Opcion 2',
                      Icons.info,
                      () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opcion 2 seleccionada')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      themeProvider,
                      'Opcion 3',
                      Icons.help,
                      () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opcion 3 seleccionada')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: themeProvider.lightAccent,
                      width: 1,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: themeProvider.textPrimary,
                  ),
                  title: Text(
                    themeProvider.isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
                    style: GoogleFonts.lexendDeca(
                      color: themeProvider.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: themeProvider.secondaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    ThemeProvider themeProvider,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: themeProvider.textPrimary,
      ),
      title: Text(
        title,
        style: GoogleFonts.lexendDeca(
          color: themeProvider.textPrimary,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}