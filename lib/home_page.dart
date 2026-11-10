import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'archive_page.dart';
import 'device_page.dart';
import 'equipment_page.dart';
import 'page_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtorepPageBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'HOME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'AT A GLANCE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _metricTile('142', 'DEVICES'),
                      const SizedBox(width: 8),
                      _metricTile('100', 'UP'),
                      const SizedBox(width: 8),
                      _metricTile('3', 'DOWN'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _summaryTile(
                    context,
                    icon: Icons.laptop_mac_rounded,
                    title: 'DEVICE',
                    detail: '3 computers need attention',
                    page: const DevicePage(),
                  ),
                  const SizedBox(height: 12),
                  _summaryTile(
                    context,
                    icon: Icons.settings_rounded,
                    title: 'EQUIPMENT',
                    detail: '142 registered computers',
                    page: const EquipmentPage(),
                  ),
                  const SizedBox(height: 12),
                  _summaryTile(
                    context,
                    icon: Icons.work_outline_rounded,
                    title: 'ARCHIVE',
                    detail: 'Recent maintenance reports',
                    page: const ArchivePage(),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'RECENT ACTIVITY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _activityRow(
                    Icons.build_circle_outlined,
                    'PC-09 | ADV.LAB',
                    'Needs service',
                    const Color(0xFFFFD43B),
                  ),
                  _activityRow(
                    Icons.check_circle_outline,
                    'PC-01 | ADV.LAB',
                    'Maintenance completed',
                    AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK TO DEVICE'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _metricTile(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityRow(
    IconData icon,
    String device,
    String detail,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              device,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            detail,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String detail,
    required Widget page,
  }) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => page),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        alignment: Alignment.centerLeft,
        side: const BorderSide(color: Colors.white24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}
