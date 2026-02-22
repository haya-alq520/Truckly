import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/review.dart';

class ReviewsService {
  final _client = Supabase.instance.client;

  Future<List<Review>> getReviews(String truckId) async {
    final data = await _client
        .from('reviews')
        .select()
        .eq('truck_id', truckId)
        .order('created_at', ascending: false);

    return (data as List).map((e) => Review.fromMap(e)).toList();
  }

  Future<void> addReview({
    required String truckId,
    required int rating,
    required String? comment,
    required List<String> imageUrls,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    await _client.from('reviews').insert({
      'truck_id': truckId,
      'user_id': user.id,
      'rating': rating,
      'comment': comment,
      'image_urls': imageUrls,
    });
  }
}
