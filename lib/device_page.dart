import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'archive_page.dart';
import 'equipment_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = screenWidth > 430 ? 420.0 : screenWidth - 28;

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
              child: SizedBox(
                width: cardWidth,
                child: Container(
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.45),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 18),
                      _buildIconStrip(context),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'e.g. ADV.LAB | PC 09',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Device Monitoring',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildMonitoringCard(),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildIssueCard(
                              'Recently Fixed',
                              _recentlyFixedList,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildIssueCard(
                              'Needs Service',
                              _needsServiceList,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _buildCriticalCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _headerButton(
          icon: Icons.person_rounded,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              height: 52,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.elevatedSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'DEVICE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
        _headerButton(
          icon: Icons.home_rounded,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HomePage()),
          ),
        ),
      ],
    );
  }

  Widget _headerButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 54,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.elevatedSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: IconButton(
          onPressed: onPressed,
          tooltip: icon == Icons.home_rounded ? 'Home' : 'Profile',
          icon: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  Widget _buildIconStrip(BuildContext context) {
    final icons = [
      Icons.laptop_mac_rounded,
      Icons.settings_rounded,
      Icons.work_outline_rounded,
    ];
    final destinations = [
      null,
      const EquipmentPage(),
      const ArchivePage(),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          return SizedBox(
            width: 58,
            height: 52,
            child: IconButton(
              onPressed: () {
                final destination = destinations[index];
                if (destination != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => destination),
                  );
                }
              },
              tooltip: const [
                'Device',
                'Equipment',
                'Archive',
              ][index],
              icon: Icon(
                icons[index],
                color: Colors.white.withValues(alpha: 0.75),
                size: 28,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMonitoringCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildDeviceStatus(
            'PC-01 | ADV.LAB',
            'ONLINE',
            AppColors.primary,
          ),
          const Divider(color: Colors.white24, height: 20),
          _buildDeviceStatus(
            'PC-09 | ADV.LAB',
            'NEEDS SERVICE',
            const Color(0xFFFF4F4F),
          ),
          const Divider(color: Colors.white24, height: 20),
          _buildDeviceStatus(
            'PC-07 | MAC LAB',
            'ONLINE',
            AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceStatus(String device, String status, Color statusColor) {
    return Row(
      children: [
        Expanded(
          child: Text(
            device,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Icon(Icons.circle, color: statusColor, size: 12),
        const SizedBox(width: 8),
        Text(
          status,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildIssueCard(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6, right: 8),
                    child: Icon(Icons.circle, size: 7, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Critical',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ..._criticalList.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5, right: 7),
                    child: Icon(Icons.circle, size: 7, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> _recentlyFixedList = [
    '• PC - 01 in ADV.LAB',
    '• PC - 08 in ADV.LAB',
    '• PC - 07 in MAC LAB',
    '• Server - 01 in MAC LAB',
  ];

  static const List<String> _needsServiceList = [
    '• PC - 09 in ADV.LAB',
    '• PC - 07 in MAC LAB',
    '• PC - 01 in ADV.LAB',
    '• PC - 03 in ADV.LAB',
  ];

  static const List<String> _criticalList = [
    '• PC - 06 in ADV.LAB | Blue Screen of Death',
    '• PC - 07 in MAC LAB | Random Boots',
    '• PC - 01 in ADV.LAB | Virus',
  ];
}
