import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'page_background.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  final List<String> _devices = [
    'PC-01 | ADV.LAB',
    'PC-07 | MAC LAB',
    'PC-09 | ADV.LAB',
  ];
  final List<String> _statuses = ['UP', 'UP', 'WIP'];

  Future<void> _addDevice() async {
    final controller = TextEditingController();
    final device = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add equipment'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. PC-10 | ADV.LAB'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('ADD'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (device != null && device.isNotEmpty) {
      setState(() {
        _devices.add(device);
        _statuses.add('UP');
      });
    }
  }

  Future<void> _editDevice(int index) async {
    final controller = TextEditingController(text: _devices[index]);
    final device = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit equipment'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (device != null && device.isNotEmpty) {
      setState(() => _devices[index] = device);
    }
  }

  void _deleteDevice(int index) {
    setState(() {
      _devices.removeAt(index);
      _statuses.removeAt(index);
    });
  }

  void _setStatus(int index, String status) {
    setState(() => _statuses[index] = status);
  }

  Future<void> _showDeviceActions(int index) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit equipment'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete equipment'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.flag, color: _statusColor('UP')),
              title: const Text('UP - Working properly'),
              onTap: () => Navigator.pop(context, 'UP'),
            ),
            ListTile(
              leading: Icon(Icons.flag, color: _statusColor('WIP')),
              title: const Text('WIP - Under maintenance'),
              onTap: () => Navigator.pop(context, 'WIP'),
            ),
            ListTile(
              leading: Icon(Icons.flag, color: _statusColor('DOWN')),
              title: const Text('DOWN - Needs repair'),
              onTap: () => Navigator.pop(context, 'DOWN'),
            ),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;
    if (action == 'edit') {
      await _editDevice(index);
    } else if (action == 'delete') {
      _deleteDevice(index);
    } else {
      _setStatus(index, action);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'UP':
        return AppColors.primary;
      case 'WIP':
        return const Color(0xFFFFD43B);
      default:
        return const Color(0xFFFF4F4F);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtorepPageBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      'EQUIPMENT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addDevice,
                    tooltip: 'Add equipment',
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatusFlags(),
              const SizedBox(height: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: ListView.separated(
                    itemCount: _devices.length,
                    separatorBuilder: (_, _) => const Divider(color: Colors.white24),
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.computer, color: Colors.white),
                      title: Text(
                        _devices[index],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.flag,
                            color: _statusColor(_statuses[index]),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _statuses[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () => _showDeviceActions(index),
                        tooltip: 'Manage equipment',
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFlags() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statusFlag('UP', 'Working properly'),
          _statusFlag('WIP', 'Under maintenance'),
          _statusFlag('DOWN', 'Needs repair'),
        ],
      ),
    );
  }

  Widget _statusFlag(String status, String meaning) {
    return Expanded(
      child: Column(
        children: [
          Icon(Icons.flag, color: _statusColor(status), size: 24),
          const SizedBox(height: 3),
          Text(
            status,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            meaning,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 9),
          ),
        ],
      ),
    );
  }
}
