import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../colors.dart';
import '../../widgets/auth/animated_background.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/login_dialog.dart';
import '../../widgets/auth/password_field.dart';
import '../../widgets/auth/social_login_buttons.dart';
import '../../widgets/auth/remember_me_row.dart';
import '../../widgets/auth/primary_button.dart';
import '../../widgets/auth/sliding_panel.dart';
//import '../home/feed.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // Simulation d'appel API
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const Scaffold(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  void _showForgotPasswordDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LoginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: AuthHeader(
                    title: 'Connexion',
                    subtitle: 'Bienvenue sur ConnctWork',
                  ),
                ),
                
                // Panel coulissant
                Expanded(
                  child: SlidingPanel(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(28),
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),
                            
                            // Email
                            AuthTextField(
                              icon: Icons.email_outlined,
                              hint: 'nom@exemple.com',
                              label: 'Email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value?.isEmpty ?? true) return 'Email requis';
                                if (!value!.contains('@')) return 'Email invalide';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            
                            // Password
                            PasswordField(
                              controller: _passwordController,
                              label: 'Mot de passe',
                              onSubmitted: _login,
                            ),
                            const SizedBox(height: 28),
                            
                            // Login button
                            PrimaryButton(
                              text: 'Se connecter',
                              isLoading: _isLoading,
                              onPressed: _login,
                              icon: Icons.arrow_forward,
                            ),
                            const SizedBox(height: 28),

                            // Remember me & Forgot password
                            RememberMeRow(
                              onForgotPassword: _showForgotPasswordDialog,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
