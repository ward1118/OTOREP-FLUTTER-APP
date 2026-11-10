import 'package:flutter/material.dart';

import 'app_colors.dart';

class OtorepPageBackground extends StatelessWidget {
  const OtorepPageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Stack(
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SizedBox(
                  width: double.infinity,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtorepPageBackground(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('BACK TO DEVICE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
