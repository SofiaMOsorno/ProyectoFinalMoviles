import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/edit_profile_modal.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:proyecto_final/services/profile_picture_service.dart';

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
              _buildLogoutButton(context, themeProvider),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, ThemeProvider themeProvider) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    final pictureService = ProfilePictureService();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: BoxDecoration(
        color: themeProvider.secondaryColor,
      ),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: user != null ? _getUserDataWithLocalPicture(authService, pictureService, user.uid) : null,
        builder: (context, snapshot) {
          final userData = snapshot.data;
          final username = userData?['username'] ?? user?.displayName ?? 'User';
          final email = user?.email ?? '';
          final localPicturePath = userData?['localPicturePath'] as String?;
          final profilePicture = userData?['profilePicture'] ?? user?.photoURL;
          final firstLetter = username.isNotEmpty ? username[0].toUpperCase() : 'U';

          return Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: themeProvider.primaryColor,
                backgroundImage: _getProfileImage(localPicturePath, profilePicture),
                child: (localPicturePath == null && profilePicture == null)
                    ? Text(
                        firstLetter,
                        style: GoogleFonts.ericaOne(
                          color: themeProvider.textPrimary,
                          fontSize: 48,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                username,
                style: GoogleFonts.ericaOne(
                  color: themeProvider.primaryColor,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              if (email.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  email,
                  style: GoogleFonts.lexendDeca(
                    color: themeProvider.primaryColor.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
                  'Edit my data',
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
          );
        },
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

  Widget _buildLogoutButton(BuildContext context, ThemeProvider themeProvider) {
    final authService = Provider.of<AuthService>(context, listen: false);

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
          Icons.logout,
          color: themeProvider.textPrimary,
          size: 28,
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () async {
          try {
            await authService.signOut();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error logging out: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      ),
    );
  }

  Future<Map<String, dynamic>?> _getUserDataWithLocalPicture(
    AuthService authService,
    ProfilePictureService pictureService,
    String uid,
  ) async {
    final userData = await authService.getUserData(uid);
    final localPicturePath = await pictureService.getLocalProfilePicturePath(uid);

    if (userData != null) {
      return {
        ...userData,
        'localPicturePath': localPicturePath,
      };
    }

    return {'localPicturePath': localPicturePath};
  }

  ImageProvider? _getProfileImage(String? localPath, String? networkUrl) {
    if (localPath != null) {
      return FileImage(File(localPath));
    }

    if (networkUrl != null) {
      return NetworkImage(networkUrl);
    }

    return null;
  }
}