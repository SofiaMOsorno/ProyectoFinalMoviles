import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/custom_text_field.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

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
      await authService.registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
      );

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
                          _buildUploadSection(context, themeProvider),
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

Widget _buildUploadSection(BuildContext context, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload profile pic',
          style: TextStyle(
            color: themeProvider.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 70,
          decoration: BoxDecoration(
            color: themeProvider.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('File picker coming soon'),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: themeProvider.lightAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.upload_file,
                    color: themeProvider.backgroundColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Upload a File',
                  style: TextStyle(
                    color: themeProvider.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }