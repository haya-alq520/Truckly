import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final _client = Supabase.instance.client;
  final _uuid = const Uuid();

  Future<String> uploadReviewImage(File file) async {
    final ext = file.path.split('.').last;
    final path = 'reviews/${_uuid.v4()}.$ext';

    await _client.storage.from('review-images').upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: false),
        );

    return _client.storage.from('review-images').getPublicUrl(path);
  }

  Future<String> uploadTruckImage(File file) async {
    final ext = file.path.split('.').last;
    final path = 'trucks/${_uuid.v4()}.$ext';

    await _client.storage.from('truck-images').upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: false),
        );

    return _client.storage.from('truck-images').getPublicUrl(path);
  }
}
