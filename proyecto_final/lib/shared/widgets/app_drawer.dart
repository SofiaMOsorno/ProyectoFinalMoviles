import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/edit_profile_modal.dart';

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
              _buildProfileHeader(context, themeProvider),
              _buildMenuItems(context, themeProvider),
              _buildDarkModeToggle(themeProvider),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: BoxDecoration(
        color: themeProvider.secondaryColor,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: themeProvider.primaryColor,
            child: Text(
              'A',
              style: GoogleFonts.ericaOne(
                color: themeProvider.textPrimary,
                fontSize: 48,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Alan el platano',
            style: GoogleFonts.ericaOne(
              color: themeProvider.primaryColor,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const EditProfileModal();
                },
              );
            },
            icon: Icon(
              Icons.edit,
              color: themeProvider.secondaryColor,
              size: 18,
            ),
            label: Text(
              'Editar mis datos',
              style: GoogleFonts.lexendDeca(
                color: themeProvider.secondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, ThemeProvider themeProvider) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildMenuItem(
            context,
            themeProvider,
            'Home',
            Icons.home,
            () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          ),
          _buildMenuItem(
            context,
            themeProvider,
            'Created Queues',
            Icons.star,
            () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/created-queues');
            },
          ),
        ],
      ),
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
        size: 28,
      ),
      title: Text(
        title,
        style: GoogleFonts.lexendDeca(
          color: themeProvider.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }

  Widget _buildDarkModeToggle(ThemeProvider themeProvider) {
    return Container(
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
          size: 28,
        ),
        title: Text(
          'Dark Mode',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
          activeColor: themeProvider.secondaryColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      ),
    );
  }
}