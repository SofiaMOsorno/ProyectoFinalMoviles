import 'dart:io';
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

  File? _selectedImage;
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
      setState(() {
        _currentUsername = userData?['username'] ?? user.displayName ?? 'User';
        _nameController.text = _currentUsername;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final source = await _showImageSourceDialog();
      if (source == null) return;

      File? image;
      if (source == ImageSource.gallery) {
        image = await _pictureService.pickImageFromGallery();
      } else {
        image = await _pictureService.pickImageFromCamera();
      }

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error selecting image: $e');
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return AlertDialog(
          backgroundColor: themeProvider.textField,
          title: Text(
            'Select image from',
            style: GoogleFonts.lexendDeca(
              color: themeProvider.secondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: themeProvider.secondaryColor),
                title: Text(
                  'Gallery',
                  style: GoogleFonts.lexendDeca(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: themeProvider.secondaryColor),
                title: Text(
                  'Camera',
                  style: GoogleFonts.lexendDeca(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
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
    if (_selectedImage == null) {
      _showErrorSnackBar('No image selected');
      return;
    }

    setState(() => _isLoadingPicture = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;

      if (user != null) {
        await _pictureService.saveProfilePicture(_selectedImage!, user.uid);

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
                  _buildPictureUpload(themeProvider),
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

  Widget _buildPictureUpload(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Picture',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.secondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (_selectedImage != null) ...[
          Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _selectedImage!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Container(
          decoration: BoxDecoration(
            color: themeProvider.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: themeProvider.secondaryColor,
              width: 3,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _pickImage,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: themeProvider.lightAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.upload_file,
                            color: themeProvider.backgroundColor,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          _selectedImage == null ? 'Upload a File' : 'Change File',
                          style: GoogleFonts.lexendDeca(
                            color: themeProvider.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _selectedImage != null
                      ? themeProvider.secondaryColor
                      : themeProvider.lightAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isLoadingPicture
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
                        onPressed: _selectedImage != null ? _updateProfilePicture : null,
                        padding: const EdgeInsets.all(8),
                      ),
              ),
            ],
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

enum ImageSource { gallery, camera }
