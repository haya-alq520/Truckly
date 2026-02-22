import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_theme.dart';
import '../../models/food_truck.dart';
import '../../models/review.dart';
import '../../services/trucks_service.dart';
import '../../services/reviews_service.dart';

class TruckDetailsScreen extends StatefulWidget {
  final String truckId;
  const TruckDetailsScreen({super.key, required this.truckId});

  @override
  State<TruckDetailsScreen> createState() => _TruckDetailsScreenState();
}

class _TruckDetailsScreenState extends State<TruckDetailsScreen> {
  final _trucks = TrucksService();
  final _reviews = ReviewsService();

  late Future<FoodTruck> _truckFuture;
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _truckFuture = _trucks.getTruckById(widget.truckId);
    _reviewsFuture = _reviews.getReviews(widget.truckId);
  }

  Future<void> _refreshReviews() async {
    setState(() => _reviewsFuture = _reviews.getReviews(widget.truckId));
  }

  Future<void> _openMaps(String url) async {
    final uri = Uri.tryParse(url);

    final safeUri = (uri == null)
        ? Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(url)}',
          )
        : uri;

    final ok = await launchUrl(
      safeUri,
      mode: LaunchMode.externalApplication,
    );

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FoodTruck>(
      future: _truckFuture,
      builder: (context, truckSnap) {
        if (truckSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (truckSnap.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${truckSnap.error}')),
          );
        }

        final truck = truckSnap.data!;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔙 زر الرجوع
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Spacer(),
                    ],
                  ),

                  Container(
                    height: 190,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEFC5),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: truck.coverImageUrl == null
                        ? const Center(
                            child: Icon(Icons.local_shipping_outlined, size: 44),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: Image.network(
                              truck.coverImageUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    truck.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    truck.category ?? '—',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    truck.locationName ?? '—',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: truck.googleMapsUrl == null
                              ? null
                              : () => _openMaps(truck.googleMapsUrl!),
                          icon: const Icon(Icons.map_outlined),
                          label: const Text('Open in Maps'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.text,
                            side: const BorderSide(color: AppTheme.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          
                          onPressed: () => context.push(
                              '/details/${truck.id}/add-review'),
                          icon: const Icon(Icons.rate_review_outlined),
                          label: const Text('Add Review'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.olive,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  Text(
                    'Reviews',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.text,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: FutureBuilder<List<Review>>(
                      future: _reviewsFuture,
                      builder: (context, snap) {
                        if (snap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snap.hasError) {
                          return Center(
                              child: Text('Error: ${snap.error}'));
                        }

                        final reviews = snap.data ?? [];

                        if (reviews.isEmpty) {
                          return const Center(
                              child: Text('No reviews yet.'));
                        }

                        return RefreshIndicator(
                          onRefresh: _refreshReviews,
                          child: ListView.separated(
                            itemCount: reviews.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final r = reviews[i];
                              return Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '⭐ ${r.rating}',
                                            style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.w800),
                                          ),
                                          const Spacer(),
                                          Text(
                                              r.createdAt
                                                      ?.toString() ??
                                                  ''),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(r.comment ?? '—'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}