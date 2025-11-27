import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/custom_text_field.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final/services/profile_picture_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final ProfilePictureService _pictureService = ProfilePictureService();
  String? _selectedPresetImage;
  File? _selectedGalleryImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorSnackBar('Missing fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Passwords dont match');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorSnackBar('Password must have at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userCredential = await authService.registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
      );

      if (userCredential?.user != null) {
        String? profilePicturePath;
        String? profilePictureType;

        if (_selectedPresetImage != null) {
          await _pictureService.savePresetProfilePicture(
            _selectedPresetImage!,
            userCredential!.user!.uid,
          );
          profilePicturePath = _selectedPresetImage;
          profilePictureType = 'preset';
        } else if (_selectedGalleryImage != null) {
          await _pictureService.saveGalleryProfilePicture(
            _selectedGalleryImage!.path,
            userCredential!.user!.uid,
          );
          profilePicturePath = 'gallery_${userCredential.user!.uid}';
          profilePictureType = 'gallery';
        }

        if (profilePicturePath != null && profilePictureType != null) {
          await authService.updateUserProfile(
            uid: userCredential!.user!.uid,
            profilePicture: profilePicturePath,
          );
          
          // Actualizar también el tipo de imagen en Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .update({'profilePictureType': profilePictureType});
        }
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/create-queue');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleRegister() async {
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userCredential = await authService.signInWithGoogle();

      if (userCredential != null && mounted) {
        Navigator.pushReplacementNamed(context, '/create-queue');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF6B1D5C),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  Future<void> _pickImageFromGallery() async {
    try {
      // Solicitar permisos
      final status = await Permission.photos.request();
      
      if (status.isGranted || status.isLimited) {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );

        if (pickedFile != null) {
          setState(() {
            _selectedGalleryImage = File(pickedFile.path);
            _selectedPresetImage = null;
          });
        }
      } else if (status.isPermanentlyDenied) {
        if (mounted) {
          _showErrorSnackBar('Please enable gallery access in settings');
        }
      } else {
        if (mounted) {
          _showErrorSnackBar('Gallery access denied');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error picking image: $e');
      }
    }
  }

  Widget _buildProfilePictureSection(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a profile pic',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ProfilePictureService.presetImages.length,
            itemBuilder: (context, index) {
              final imagePath = ProfilePictureService.presetImages[index];
              final isSelected = _selectedPresetImage == imagePath;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPresetImage = imagePath;
                    _selectedGalleryImage = null;
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
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Separador con texto
        Text(
          'Or select a picture from your gallery',
          style: GoogleFonts.lexendDeca(
            color: themeProvider.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        // Botón y preview de galería
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _pickImageFromGallery,
                  child: Text(
                    'Select from gallery',
                    style: GoogleFonts.lexendDeca(
                      color: themeProvider.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            if (_selectedGalleryImage != null) ...[
              const SizedBox(width: 12),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: themeProvider.secondaryColor,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.file(
                    _selectedGalleryImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryColor,
          appBar: AppBar(
            backgroundColor: themeProvider.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: themeProvider.textPrimary),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Create Queue',
                        height: 100,
                        backgroundColor: themeProvider.secondaryColor,
                        textStyle: GoogleFonts.ericaOne(
                          color: themeProvider.primaryColor,
                          fontSize: 43,
                        ),
                        borderRadius: 0,
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          CustomTextField(
                            label: 'Create username*',
                            controller: _usernameController,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            label: 'Email*',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            label: 'Password*',
                            controller: _passwordController,
                            obscureText: true,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            label: 'Confirm Password*',
                            controller: _confirmPasswordController,
                            obscureText: true,
                          ),
                          const SizedBox(height: 15),
                          _buildProfilePictureSection(themeProvider),
                          const SizedBox(height: 30),
                          CustomButton(
                            text: 'Register',
                            backgroundColor: themeProvider.secondaryColor,
                            textStyle: GoogleFonts.ericaOne(
                              color: themeProvider.textPrimary,
                              fontSize: 28,
                            ),
                            onPressed: _isLoading ? () {} : _handleRegister,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "or",
                            style: TextStyle(
                              color: themeProvider.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomButton(
                                height: 40,
                                width: 300,
                                text: '',
                                backgroundColor: themeProvider.secondaryColor,
                                textStyle: GoogleFonts.ericaOne(
                                  color: Colors.transparent,
                                  fontSize: 18,
                                ),
                                onPressed: _isLoading ? () {} : _handleGoogleRegister,
                              ),
                              IgnorePointer(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'REGISTER WITH ',
                                      style: GoogleFonts.ericaOne(
                                        color: themeProvider.textPrimary,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Image.asset(
                                      'assets/images/google_logo.png',
                                      height: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: themeProvider.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15),
                          CustomButton(
                            text: 'Login',
                            backgroundColor: themeProvider.secondaryColor,
                            textStyle: GoogleFonts.ericaOne(
                              color: themeProvider.textPrimary,
                              fontSize: 28,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: themeProvider.secondaryColor,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

