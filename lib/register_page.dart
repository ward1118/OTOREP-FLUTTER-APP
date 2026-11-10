import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'device_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DevicePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.34,
              child: Image.asset(
                'lib/otorep_logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 520,
                    minHeight: size.height - 32,
                  ),
                  child: Container(
                        padding: EdgeInsets.fromLTRB(
                          size.width < 380 ? 18 : 30,
                          38,
                          size.width < 380 ? 18 : 30,
                          28,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.92),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          const Text(
                            'OTOREP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'MONITORING & MANAGEMENT SYSTEM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Hello',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 58,
                                height: 0.95,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'New User!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildField(
                            controller: _usernameController,
                            icon: Icons.person_outline,
                            hint: 'Username',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          _buildField(
                            controller: _emailController,
                            icon: Icons.mail_outline,
                            hint: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          _buildField(
                            controller: _roleController,
                            icon: Icons.badge_outlined,
                            hint: 'Input your role',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter your role';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          _buildField(
                            controller: _passwordController,
                            icon: Icons.lock_outline,
                            hint: 'Create your own password',
                            obscureText: _obscurePassword,
                            suffix: IconButton(
                              tooltip: _obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password recovery link requested.'),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Forgot your password?',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 180,
                            height: 54,
                            child: FilledButton(
                              onPressed: _submitRegistration,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text('SIGN IN'),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                ),
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                            ],
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white, size: 24),
        suffixIcon: suffix,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}

class CircularArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final arc1 = Path();
    arc1.addArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.86,
        height: size.height * 0.86,
      ),
      1.85 * 3.14159,
      1.8 * 3.14159,
    );
    canvas.drawPath(arc1, paint);

    final arc2 = Path();
    arc2.addArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.72,
        height: size.height * 0.72,
      ),
      2.2 * 3.14159,
      1.8 * 3.14159,
    );
    canvas.drawPath(arc2, paint);

    final arrowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final arrowPath = Path()
      ..moveTo(size.width * 0.18, size.height * 0.72)
      ..lineTo(size.width * 0.58, size.height * 0.72)
      ..lineTo(size.width * 0.52, size.height * 0.60)
      ..lineTo(size.width * 0.82, size.height * 0.60)
      ..lineTo(size.width * 0.82, size.height * 0.45)
      ..lineTo(size.width * 0.52, size.height * 0.45)
      ..lineTo(size.width * 0.58, size.height * 0.33)
      ..lineTo(size.width * 0.18, size.height * 0.33)
      ..close();

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
