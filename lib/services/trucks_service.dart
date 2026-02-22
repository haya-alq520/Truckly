import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_truck.dart';

class TrucksService {
  final _client = Supabase.instance.client;

  Future<List<FoodTruck>> getTrucks() async {
    final data = await _client
        .from('food_trucks')
        .select()
        .order('created_at', ascending: false);

    return (data as List).map((e) => FoodTruck.fromMap(e)).toList();
  }

  Future<FoodTruck> getTruckById(String id) async {
    final data = await _client.from('food_trucks').select().eq('id', id).single();
    return FoodTruck.fromMap(data);
  }
}
