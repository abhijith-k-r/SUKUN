// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sukun/features/quran/models/reading_progress_model.dart';

// ! ========(SOMETHING ) ========
class RecentlyReadCard extends StatelessWidget {
  final ReadingProgress? progress;

  const RecentlyReadCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress == null) {
      // Guest user – just hide entire section
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recently Read', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Al-Fatihah', // map from progress.surahNumber
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ayah ${progress!.ayahNumber}',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress!.percentage,
                        minHeight: 4,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Text('${(progress!.percentage * 100).round()}%'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to reading screen at saved surah/ayah
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2DA463),
                      minimumSize: const Size(90, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
