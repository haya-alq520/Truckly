class Review {
  final String id;
  final String truckId;
  final String userId;
  final int rating;
  final String? comment;
  final List<String> imageUrls;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.truckId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.imageUrls,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> m) {
    return Review(
      id: m['id'] as String,
      truckId: m['truck_id'] as String,
      userId: m['user_id'] as String,
      rating: (m['rating'] as num).toInt(),
      comment: m['comment'] as String?,
      imageUrls: (m['image_urls'] as List<dynamic>? ?? []).cast<String>(),
      createdAt: DateTime.parse(m['created_at'] as String),
    );
  }
}
