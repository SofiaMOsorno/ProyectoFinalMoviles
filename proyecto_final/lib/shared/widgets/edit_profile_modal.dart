import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:proyecto_final/services/profile_picture_service.dart';

class EditProfileModal extends StatefulWidget {
  const EditProfileModal({super.key});

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  final TextEditingController _nameController = TextEditingController();
  final ProfilePictureService _pictureService = ProfilePictureService();

  String? _selectedPresetImage;
  bool _isLoadingName = false;
  bool _isLoadingPicture = false;
  String _currentUsername = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    if (user != null) {
      final userData = await authService.getUserData(user.uid);
      final currentPreset = await _pictureService.getCurrentPresetImage(user.uid);
      setState(() {
        _currentUsername = userData?['username'] ?? user.displayName ?? 'User';
        _nameController.text = _currentUsername;
        _selectedPresetImage = currentPreset;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateUsername() async {
    final newUsername = _nameController.text.trim();

    if (newUsername.isEmpty) {
      _showErrorSnackBar('Name cannot be empty');
      return;
    }

    if (newUsername == _currentUsername) {
      _showErrorSnackBar('Name is the same');
      return;
    }

    setState(() => _isLoadingName = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;

      if (user != null) {
        await authService.updateUserProfile(
          uid: user.uid,
          username: newUsername,
        );

        setState(() {
          _currentUsername = newUsername;
        });

        if (mounted) {
          _showSuccessSnackBar('Name updated successfully');
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error updating name: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingName = false);
      }
    }
  }

  Future<void> _updateProfilePicture() async {
    if (_selectedPresetImage == null) {
      _showErrorSnackBar('No image selected');
      return;
    }

    setState(() => _isLoadingPicture = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;

      if (user != null) {
        // Guardar localmente
        await _pictureService.savePresetProfilePicture(_selectedPresetImage!, user.uid);
        
        // Actualizar en Firebase con la ruta del asset
        await authService.updateUserProfile(
          uid: user.uid,
          profilePicture: _selectedPresetImage,
        );

        if (mounted) {
          _showSuccessSnackBar('Profile picture updated successfully');
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error updating picture: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingPicture = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF6B1D5C),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Dialog(
          backgroundColor: themeProvider.textField,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: themeProvider.secondaryColor,
                width: 8,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit\nProfile',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ericaOne(
                      color: themeProvider.secondaryColor,
                      fontSize: 48,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This information will be visible\nto all users in your queue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendDeca(
                      color: themeProvider.secondaryColor,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildNameField(themeProvider),
                  const SizedBox(height: 20),
                  _buildPresetImageSelector(themeProvider),
                  const SizedBox(height: 24),
                  _buildCancelButton(context, themeProvider),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameField(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Name',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.secondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.textPrimary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: themeProvider.secondaryColor,
              width: 3,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  style: GoogleFonts.lexendDeca(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: themeProvider.secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isLoadingName
                    ? Padding(
                        padding: const EdgeInsets.all(14),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: themeProvider.textPrimary,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.check),
                        color: themeProvider.textPrimary,
                        iconSize: 28,
                        onPressed: _updateUsername,
                        padding: const EdgeInsets.all(8),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetImageSelector(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Profile Picture',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.secondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 8,
            radius: const Radius.circular(10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ProfilePictureService.presetImages.length,
              padding: const EdgeInsets.only(bottom: 10),
              itemBuilder: (context, index) {
                final imagePath = ProfilePictureService.presetImages[index];
                final isSelected = _selectedPresetImage == imagePath;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPresetImage = imagePath;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected 
                            ? themeProvider.secondaryColor 
                            : themeProvider.lightAccent,
                        width: isSelected ? 4 : 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        imagePath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: themeProvider.lightAccent,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: themeProvider.secondaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedPresetImage != null
                  ? themeProvider.secondaryColor
                  : themeProvider.lightAccent.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            onPressed: _selectedPresetImage != null && !_isLoadingPicture
                ? _updateProfilePicture
                : null,
            child: _isLoadingPicture
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: themeProvider.textPrimary,
                    ),
                  )
                : Text(
                    'CONFIRM PICTURE',
                    style: GoogleFonts.ericaOne(
                      color: themeProvider.textPrimary,
                      fontSize: 22,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context, ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'CANCEL',
          style: GoogleFonts.ericaOne(
            color: themeProvider.textPrimary,
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}