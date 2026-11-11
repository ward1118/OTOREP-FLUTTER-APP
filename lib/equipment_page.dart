import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_colors.dart';
import 'device_repository.dart';
import 'page_background.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  late final DeviceRepository _repository;
  List<DeviceRecord> _devices = [];
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _repository = DeviceRepository(Supabase.instance.client);
    _loadDevices();
  }

  Future<bool> _loadDevices({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }
    try {
      final devices = await _repository.list();
      if (!mounted) return false;
      setState(() {
        _devices = devices;
        _isLoading = false;
        _loadError = null;
      });
      return true;
    } on Exception catch (error) {
      if (!mounted) return false;
      setState(() {
        _isLoading = false;
        _loadError = deviceLoadErrorMessage(error);
      });
      return false;
    }
  }

  Future<void> _refreshDevices() async {
    await _loadDevices();
  }

  Future<DeviceFormData?> _showDeviceForm({DeviceRecord? device}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: device?.name ?? '');
    final locationController = TextEditingController(
      text: device?.location ?? '',
    );
    final notesController = TextEditingController(text: device?.notes ?? '');
    var status = device?.status ?? 'UP';

    final result = await showDialog<DeviceFormData>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(device == null ? 'Add device' : 'Edit device'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Device name'),
                    validator: _requiredValidator,
                  ),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: _requiredValidator,
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(value: 'UP', child: Text('UP')),
                      DropdownMenuItem(value: 'WIP', child: Text('WIP')),
                      DropdownMenuItem(value: 'DOWN', child: Text('DOWN')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => status = value);
                      }
                    },
                  ),
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(labelText: 'Notes'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                final notes = notesController.text.trim();
                Navigator.pop(context, (
                  name: nameController.text.trim(),
                  location: locationController.text.trim(),
                  status: status,
                  notes: notes.isEmpty ? null : notes,
                ));
              },
              child: Text(device == null ? 'ADD' : 'SAVE'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    locationController.dispose();
    notesController.dispose();
    return result;
  }

  String? _requiredValidator(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  Future<void> _addDevice() async {
    final device = await _showDeviceForm();
    if (device == null) return;
    await _performDeviceAction(
      () => _repository.add(device),
      successMessage: 'Device added.',
    );
  }

  Future<void> _editDevice(DeviceRecord current) async {
    final device = await _showDeviceForm(device: current);
    if (device == null) return;
    await _performDeviceAction(
      () => _repository.update(current.id, device),
      successMessage: 'Device updated.',
    );
  }

  Future<void> _deleteDevice(DeviceRecord device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete device?'),
        content: Text('Delete ${device.name} from ${device.location}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _performDeviceAction(
      () => _repository.delete(device.id),
      successMessage: 'Device deleted.',
    );
  }

  Future<void> _setStatus(DeviceRecord device, String status) async {
    await _performDeviceAction(
      () => _repository.update(device.id, (
        name: device.name,
        location: device.location,
        status: status,
        notes: device.notes,
      )),
      successMessage: 'Device status updated.',
    );
  }

  Future<void> _performDeviceAction(
    Future<void> Function() action, {
    required String successMessage,
  }) async {
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
      await _loadDevices(showLoading: false);
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Device update failed: $error')));
    }
  }

  Future<void> _showDeviceActions(DeviceRecord device) async {
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
      await _editDevice(device);
    } else if (action == 'delete') {
      await _deleteDevice(device);
    } else {
      await _setStatus(device, action);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'UP':
        return AppColors.primary;
      case 'WIP':
        return AppColors.secondary;
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
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _loadError != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _loadError!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                onPressed: _refreshDevices,
                                icon: const Icon(Icons.refresh),
                                label: const Text('RETRY'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _refreshDevices,
                          child: _devices.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    SizedBox(height: 120),
                                    Icon(
                                      Icons.devices_other,
                                      color: Colors.white,
                                      size: 44,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'No devices yet. Tap + to add one.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: _devices.length,
                                  separatorBuilder: (_, _) =>
                                      const Divider(color: Colors.white24),
                                  itemBuilder: (context, index) {
                                    final device = _devices[index];
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(
                                        Icons.computer,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        '${device.name} | ${device.location}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Icon(
                                            Icons.flag,
                                            color: _statusColor(device.status),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            device.status,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          if (device.notes != null) ...[
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                device.notes!,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      trailing: IconButton(
                                        onPressed: () =>
                                            _showDeviceActions(device),
                                        tooltip: 'Manage device',
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
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
