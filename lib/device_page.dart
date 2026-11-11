import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_colors.dart';
import 'archive_page.dart';
import 'device_repository.dart';
import 'equipment_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late final DeviceRepository _repository;
  late Future<List<DeviceRecord>> _devices;

  @override
  void initState() {
    super.initState();
    _repository = DeviceRepository(Supabase.instance.client);
    _devices = _repository.list();
  }

  void _reloadDevices() {
    setState(() => _devices = _repository.list());
  }

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
              child: Image.asset('lib/otorep_logo.png', fit: BoxFit.contain),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Center(
                child: SizedBox(
                  width: cardWidth,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
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
                        const SizedBox(height: 20),
                        const Text(
                          'Device Monitoring',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        FutureBuilder<List<DeviceRecord>>(
                          future: _devices,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return _messageCard(
                                deviceLoadErrorMessage(snapshot.error!),
                                action: TextButton.icon(
                                  onPressed: _reloadDevices,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('RETRY'),
                                ),
                              );
                            }

                            final devices = snapshot.data ?? [];
                            if (devices.isEmpty) {
                              return _messageCard(
                                'No devices yet. Add equipment to start '
                                'monitoring your lab inventory.',
                              );
                            }
                            return _buildMonitoringCard(devices);
                          },
                        ),
                      ],
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

  Widget _messageCard(String message, {Widget? action}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, height: 1.4),
          ),
          ?action,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _headerButton(
          icon: Icons.person_rounded,
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ProfilePage())),
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
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const HomePage())),
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
    final destinations = [null, const EquipmentPage(), const ArchivePage()];
    final tooltips = ['Device', 'Equipment', 'Archive'];

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
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => destination));
                } else {
                  _reloadDevices();
                }
              },
              tooltip: tooltips[index],
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

  Widget _buildMonitoringCard(List<DeviceRecord> devices) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var index = 0; index < devices.length; index++) ...[
            if (index > 0) const Divider(color: Colors.white24, height: 1),
            _buildDeviceStatus(devices[index]),
          ],
        ],
      ),
    );
  }

  Widget _buildDeviceStatus(DeviceRecord device) {
    final statusColor = switch (device.status) {
      'UP' => Colors.white,
      'WIP' => AppColors.secondary,
      _ => AppColors.primary,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${device.name} | ${device.location}',
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
            device.status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
