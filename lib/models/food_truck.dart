class FoodTruck {
  final String id;
  final String ownerId;
  final String name;
  final String? category;
  final String? description;
  final bool isOpen;
  final String? hours;
  final String? locationName;
  final String? googleMapsUrl;
  final String? coverImageUrl;

  FoodTruck({
    required this.id,
    required this.ownerId,
    required this.name,
    this.category,
    this.description,
    required this.isOpen,
    this.hours,
    this.locationName,
    this.googleMapsUrl,
    this.coverImageUrl,
  });

  factory FoodTruck.fromMap(Map<String, dynamic> m) {
    return FoodTruck(
      id: m['id'] as String,
      ownerId: m['owner_id'] as String,
      name: (m['name'] ?? '') as String,
      category: m['category'] as String?,
      description: m['description'] as String?,
      isOpen: (m['is_open'] ?? true) as bool,
      hours: m['hours'] as String?,
      locationName: m['location_name'] as String?,
      googleMapsUrl: m['google_maps_url'] as String?,
      coverImageUrl: m['cover_image_url'] as String?,
    );
  }
}
