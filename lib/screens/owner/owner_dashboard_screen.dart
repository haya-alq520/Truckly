import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/review.dart';
import '../../services/owner_truck_service.dart';
import '../../services/reviews_service.dart';
import '../../core/app_theme.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  final _truckService = OwnerTruckService();
  final _reviewsService = ReviewsService();

  bool loading = true;
  String? error;
  List<Review> reviews = [];
  double avgRating = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final myTruck = await _truckService.getMyTruck();

      if (myTruck == null) {
        reviews = [];
        avgRating = 0;
      } else {
        final r = await _reviewsService.getReviews(myTruck.id);
        reviews = r;

        if (r.isNotEmpty) {
          avgRating =
              r.map((e) => e.rating).reduce((a, b) => a + b) / r.length;
        } else {
          avgRating = 0;
        }
      }
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              const Text(
                "Owner Dashboard",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Average Rating",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("${reviews.length} Reviews"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Latest Reviews",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),

              if (reviews.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No reviews yet."),
                  ),
                ),

              ...reviews.map((r) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              size: 16,
                              color: i < r.rating
                                  ? AppTheme.primary
                                  : const Color(0xFFD8D1CA),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(r.comment ?? ''),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
