import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_router.dart';
import '../../core/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _profile = ProfileService();

  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _auth.login(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      final role = await _profile.getMyRole();

      if (!mounted) return;

     
      if (role == 'owner') {
        context.go(AppRoutes.owner);
      } else {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ListView(
            children: [
              const SizedBox(height: 22),

              Text(
                'Truckly',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 14),

              Text(
                'Welcome back 👋',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Log in to discover the best food trucks near you.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 18),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      PrimaryTextField(
                        controller: _email,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      PrimaryTextField(
                        controller: _password,
                        label: 'Password',
                        obscureText: true,
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                      ],

                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'Log In',
                        loading: _loading,
                        onPressed: _onLogin,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),
              TextButton(
                onPressed: () => context.go(AppRoutes.signup),
                child: const Text("Don’t have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
