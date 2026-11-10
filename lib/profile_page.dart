import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'main.dart';
import 'page_background.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'Laboratory Admin');
  final _emailController = TextEditingController(
    text: 'hello@reallygreatsite.com',
  );
  final _roleController = TextEditingController(text: 'Computer Laboratory Admin');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile changes saved.')),
    );
  }

  void _logOut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtorepPageBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 54,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'EDIT PROFILE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _buildField(
                      controller: _usernameController,
                      icon: Icons.person_outline,
                      label: 'Username',
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _emailController,
                      icon: Icons.mail_outline,
                      label: 'Email address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your email';
                        }
                        if (!value.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _roleController,
                      icon: Icons.badge_outlined,
                      label: 'Role',
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      label: 'New password',
                      obscureText: _obscurePassword,
                      suffix: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white,
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _confirmPasswordController,
                      icon: Icons.lock_reset_outlined,
                      label: 'Confirm password',
                      obscureText: _obscureConfirmPassword,
                      suffix: IconButton(
                        onPressed: () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword,
                        ),
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white,
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('SAVE CHANGES'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('BACK TO DEVICE'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _logOut,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('LOG OUT'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) return 'Enter your $label';
        return null;
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: suffix,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
