import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_theme.dart';
import '../../services/reviews_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/primary_button.dart';

class AddReviewScreen extends StatefulWidget {
  final String truckId;
  const AddReviewScreen({super.key, required this.truckId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _reviews = ReviewsService();
  final _storage = StorageService();
  final _picker = ImagePicker();

  int rating = 5;
  final comment = TextEditingController();
  final List<File> images = [];

  bool loading = false;
  String? error;

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;

    setState(() {
      images.addAll(picked.map((x) => File(x.path)));
    });
  }

  Future<void> _submit() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
     
      final urls = <String>[];
      for (final file in images) {
        final url = await _storage.uploadReviewImage(file);
        urls.add(url);
      }

    
      await _reviews.addReview(
        truckId: widget.truckId,
        rating: rating,
        comment: comment.text.trim().isEmpty ? null : comment.text.trim(),
        imageUrls: urls,
      );

      if (!mounted) return;
      context.pop(); 
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
                  const Spacer(),
                ],
              ),
              Text(
                'Add your review',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text('This will be saved in your database.', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rating', style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(5, (i) {
                          final idx = i + 1;
                          final selected = idx <= rating;
                          return IconButton(
                            onPressed: () => setState(() => rating = idx),
                            icon: Icon(
                              Icons.star,
                              color: selected ? AppTheme.primary : const Color(0xFFD8D1CA),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 6),

                      TextField(
                        controller: comment,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Comment',
                          hintText: 'Tell us what you liked (or didn’t)...',
                        ),
                      ),

                      const SizedBox(height: 12),

                      OutlinedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(images.isEmpty ? 'Add photos' : 'Add more photos (${images.length})'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.text,
                          side: const BorderSide(color: AppTheme.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),

                      if (images.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 86,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, i) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(images[i], width: 86, height: 86, fit: BoxFit.cover),
                              );
                            },
                          ),
                        ),
                      ],

                      if (error != null) ...[
                        const SizedBox(height: 10),
                        Text(error!, style: const TextStyle(color: Colors.red)),
                      ],

                      const SizedBox(height: 16),
                      PrimaryButton(text: 'Submit', loading: loading, onPressed: _submit),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
