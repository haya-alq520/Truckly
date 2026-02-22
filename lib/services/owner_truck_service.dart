import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_truck.dart';

class OwnerTruckService {
  final _client = Supabase.instance.client;

  Future<FoodTruck?> getMyTruck() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    final data = await _client
        .from('food_trucks')
        .select()
        .eq('owner_id', user.id)
        .order('created_at', ascending: false)
        .limit(1);

    final list = (data as List);
    if (list.isEmpty) return null;
    return FoodTruck.fromMap(list.first);
  }

  Future<void> upsertMyTruck({
    String? truckId,
    required String name,
    required String category,
    required String description,
    required bool isOpen,
    required String hours,
    required String locationName,
    required String googleMapsUrl,
    String? coverImageUrl,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    final payload = {
      'owner_id': user.id,
      'name': name,
      'category': category,
      'description': description,
      'is_open': isOpen,
      'hours': hours,
      'location_name': locationName,
      'google_maps_url': googleMapsUrl,
      'cover_image_url': coverImageUrl,
    };

    if (truckId == null) {
      await _client.from('food_trucks').insert(payload);
    } else {
      await _client.from('food_trucks').update(payload).eq('id', truckId);
    }
  }
}
