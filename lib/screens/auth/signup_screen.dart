import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_router.dart';
import '../../core/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthService();
  final _profile = ProfileService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  String _role = 'customer';
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await _auth.signUp(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      final user = res.user;
      if (user == null) throw Exception('Sign up failed. Try again.');

      await _profile.upsertProfile(
        userId: user.id,
        fullName: _name.text.trim(),
        role: _role,
      );

      if (!mounted) return;

     
      if (_role == 'owner') {
        context.go(AppRoutes.owner); // /owner
      } else {
        context.go(AppRoutes.home); // /home
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
                'Create your account',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose your role and start exploring food trucks.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 18),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryTextField(controller: _name, label: 'Full name'),
                      const SizedBox(height: 12),
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
                      const SizedBox(height: 16),

                      Text(
                        'Account type',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        
                          color: AppTheme.text.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        children: [
                          ChoiceChip(
                            label: const Text('Customer'),
                            selected: _role == 'customer',
                            onSelected: (_) => setState(() => _role = 'customer'),
                          ),
                          ChoiceChip(
                            label: const Text('Owner'),
                            selected: _role == 'owner',
                            onSelected: (_) => setState(() => _role = 'owner'),
                          ),
                        ],
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                      ],

                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'Create account',
                        loading: _loading,
                        onPressed: _onSignUp,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: const Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
