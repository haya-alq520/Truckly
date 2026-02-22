import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_theme.dart';
import '../../services/trucks_service.dart';
import '../../models/food_truck.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _trucksService = TrucksService();
  late Future<List<FoodTruck>> _future;

  @override
  void initState() {
    super.initState();
    _future = _trucksService.getTrucks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Discover',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.text,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Profile',
                    onPressed: () => context.push('/profile'),
                    icon: const Icon(Icons.person_outline),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Food trucks',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: FutureBuilder<List<FoodTruck>>(
                  future: _future,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(child: Text('Error: ${snap.error}'));
                    }
                    final trucks = snap.data ?? [];
                    if (trucks.isEmpty) {
                      return const Center(
                          child: Text('No trucks yet. Add one as Owner.'));
                    }

                    return ListView.separated(
                      itemCount: trucks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final t = trucks[i];
                        return InkWell(
                          borderRadius: BorderRadius.circular(24),
                         
                          onTap: () => context.push('/details/${t.id}'),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 76,
                                    height: 76,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFEFC5),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: t.coverImageUrl == null
                                        ? const Icon(Icons.local_shipping_outlined,
                                            size: 34)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            child: Image.network(
                                              t.coverImageUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                t.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: t.isOpen
                                                    ? AppTheme.olive
                                                    : const Color(0xFFB8B2AE),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Text(
                                                t.isOpen ? 'Open' : 'Closed',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(t.category ?? '—',
                                            style: const TextStyle(
                                                color: Colors.black54)),
                                        const SizedBox(height: 6),
                                        Text(t.locationName ?? '—',
                                            style: const TextStyle(
                                                color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}