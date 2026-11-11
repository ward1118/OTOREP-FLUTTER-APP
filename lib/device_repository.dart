import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceRecord {
  const DeviceRecord({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    this.notes,
  });

  final String id;
  final String name;
  final String location;
  final String status;
  final String? notes;

  factory DeviceRecord.fromJson(Map<String, dynamic> json) {
    return DeviceRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );
  }
}

typedef DeviceFormData = ({
  String name,
  String location,
  String status,
  String? notes,
});

String deviceLoadErrorMessage(Object error) {
  if (error is PostgrestException && error.code == 'PGRST205') {
    return 'The devices table is missing. Apply the '
        '20261110170000_create_devices.sql migration in Supabase, then retry.';
  }
  return 'Could not load devices: $error';
}

class DeviceRepository {
  DeviceRepository(this._client);

  final SupabaseClient _client;

  Future<List<DeviceRecord>> list() async {
    final rows = await _client
        .from('devices')
        .select('id, name, location, status, notes')
        .order('created_at', ascending: false);
    return rows
        .map((row) => DeviceRecord.fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<void> add(DeviceFormData device) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Sign in as an admin before adding devices.');
    }

    await _client.from('devices').insert({
      'name': device.name,
      'location': device.location,
      'status': device.status,
      'notes': device.notes,
      'created_by': userId,
    });
  }

  Future<void> update(String id, DeviceFormData device) async {
    await _client
        .from('devices')
        .update({
          'name': device.name,
          'location': device.location,
          'status': device.status,
          'notes': device.notes,
        })
        .eq('id', id)
        .select('id')
        .single();
  }

  Future<void> delete(String id) async {
    await _client.from('devices').delete().eq('id', id).select('id').single();
  }
}
