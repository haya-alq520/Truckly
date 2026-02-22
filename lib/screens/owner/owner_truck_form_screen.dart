import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_theme.dart';
import '../../models/food_truck.dart';
import '../../services/owner_truck_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/primary_button.dart';

class OwnerTruckFormScreen extends StatefulWidget {
  const OwnerTruckFormScreen({super.key});

  @override
  State<OwnerTruckFormScreen> createState() => _OwnerTruckFormScreenState();
}

class _OwnerTruckFormScreenState extends State<OwnerTruckFormScreen> {
  final _service = OwnerTruckService();
  final _storage = StorageService();
  final _picker = ImagePicker();

  final name = TextEditingController();
  final category = TextEditingController();
  final description = TextEditingController();
  final hours = TextEditingController();
  final locationName = TextEditingController();
  final mapsUrl = TextEditingController();

  bool isOpen = true;

  FoodTruck? myTruck;
  File? newCover;
  bool loading = true;
  bool saving = false;
  String? error;

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
      final t = await _service.getMyTruck();
      myTruck = t;

      if (t != null) {
        name.text = t.name;
        category.text = t.category ?? '';
        description.text = t.description ?? '';
        hours.text = t.hours ?? '';
        locationName.text = t.locationName ?? '';
        mapsUrl.text = t.googleMapsUrl ?? '';
        isOpen = t.isOpen;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _pickCover() async {
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x == null) return;
    setState(() => newCover = File(x.path));
  }

  Future<void> _save() async {
    setState(() {
      saving = true;
      error = null;
    });

    try {
      String? coverUrl = myTruck?.coverImageUrl;

      if (newCover != null) {
        coverUrl = await _storage.uploadTruckImage(newCover!);
      }

      await _service.upsertMyTruck(
        truckId: myTruck?.id,
        name: name.text.trim(),
        category: category.text.trim(),
        description: description.text.trim(),
        isOpen: isOpen,
        hours: hours.text.trim(),
        locationName: locationName.text.trim(),
        googleMapsUrl: mapsUrl.text.trim(),
        coverImageUrl: coverUrl,
      );

      await _load();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved ✅')),
      );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    name.dispose();
    category.dispose();
    description.dispose();
    hours.dispose();
    locationName.dispose();
    mapsUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              Text(
                myTruck == null ? 'Setup your truck' : 'Edit your truck',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cover image', style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEFC5),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: _coverWidget(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _pickCover,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Change cover'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.text,
                                side: const BorderSide(color: AppTheme.border),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(controller: name, decoration: const InputDecoration(labelText: 'Truck name')),
              const SizedBox(height: 12),
              TextField(controller: category, decoration: const InputDecoration(labelText: 'Category')),
              const SizedBox(height: 12),
              TextField(controller: description, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              TextField(controller: hours, decoration: const InputDecoration(labelText: 'Working hours')),
              const SizedBox(height: 12),
              TextField(controller: locationName, decoration: const InputDecoration(labelText: 'Location name')),
              const SizedBox(height: 12),
              TextField(controller: mapsUrl, decoration: const InputDecoration(labelText: 'Google Maps URL')),

              const SizedBox(height: 12),

              Card(
                child: SwitchListTile(
                  value: isOpen,
                  onChanged: (v) => setState(() => isOpen = v),
                  title: const Text('Open now'),
                ),
              ),

              if (error != null) ...[
                const SizedBox(height: 10),
                Text(error!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Save changes',
                loading: saving,
                onPressed: _save,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverWidget() {
    if (newCover != null) {
      return Image.file(newCover!, fit: BoxFit.cover);
    }
    if (myTruck?.coverImageUrl != null && myTruck!.coverImageUrl!.isNotEmpty) {
      return Image.network(myTruck!.coverImageUrl!, fit: BoxFit.cover);
    }
    return const Center(child: Icon(Icons.local_shipping_outlined, size: 32));
  }
}
