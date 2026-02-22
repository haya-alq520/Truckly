import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _client = Supabase.instance.client;

  Future<void> upsertProfile({
    required String userId,
    required String fullName,
    required String role, // customer | owner
  }) async {
    await _client.from('profiles').upsert({
      'id': userId,
      'full_name': fullName,
      'role': role,
    });
  }

  Future<String> getMyRole() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    final data = await _client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single();

    return data['role'] as String;
  }
}
