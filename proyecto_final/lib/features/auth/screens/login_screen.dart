import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/core/theme/theme_provider.dart';
import 'package:proyecto_final/shared/widgets/custom_button.dart';
import 'package:proyecto_final/shared/widgets/custom_text_field.dart';
import 'package:proyecto_final/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Missing fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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

  Future<void> _handleGoogleLogin() async {
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
        return WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacementNamed(context, '/');
            return false;
          },
          child: Scaffold(
            backgroundColor: themeProvider.primaryColor,
            appBar: AppBar(
              backgroundColor: themeProvider.primaryColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: themeProvider.textPrimary),
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              ),
            ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'WELCOME\nBACK!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ericaOne(
                              color: themeProvider.lightAccent,
                              fontSize: 48,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        height: 100,
                        text: 'Start a Queue',
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
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          CustomTextField(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 5),
                          CustomTextField(
                            label: 'Password',
                            controller: _passwordController,
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Login',
                            backgroundColor: themeProvider.secondaryColor,
                            textStyle: GoogleFonts.ericaOne(
                              color: themeProvider.textPrimary,
                              fontSize: 28,
                            ),
                            onPressed: _isLoading ? () {} : _handleEmailLogin,
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
                                onPressed: _isLoading ? () {} : _handleGoogleLogin,
                              ),
                              IgnorePointer(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'LOGIN WITH ',
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
                          const SizedBox(height: 25),
                          Text(
                            "Don't have an account yet?",
                            style: TextStyle(
                              color: themeProvider.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15),
                          CustomButton(
                            text: 'Register',
                            backgroundColor: themeProvider.secondaryColor,
                            textStyle: GoogleFonts.ericaOne(
                              color: themeProvider.textPrimary,
                              fontSize: 28,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
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
          ),
        );
      },
    );
  }
}