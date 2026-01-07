import 'package:flutter/material.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/views/widgets/ayah_card_widgets.dart';

// ============================================================================
// SURAH PAGE
// Single full-screen page representing one Surah
// Vertical scrolling within the page
// ============================================================================

class SurahPage extends StatelessWidget {
  final Chapter surah;
  final List<Ayah> verses;
  final bool isLoading;

  const SurahPage({
    super.key,
    required this.surah,
    required this.verses,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      // Full page container - measured like a real printed page
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        // Vertical scrolling within the page
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // Surah Header
            _SurahPageHeader(surah: surah),

            const SizedBox(height: 24),

            // Bismillah (skip for Surah 1 and 9)
            if (surah.id != 1 && surah.id != 9) ...[
              _Bismillah(),
              const SizedBox(height: 24),
            ],

            // All Ayahs in this page
            ...verses.map(
              (ayah) => PageAyahCard(ayah: ayah, surahNumber: surah.id),
            ),

            // Bottom spacing
            const SizedBox(height: 40),

            // Page indicator
            _PageIndicator(currentPage: surah.id, totalPages: 114),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SURAH PAGE HEADER
// Header at the top of each page
// ============================================================================

class _SurahPageHeader extends StatelessWidget {
  final Chapter surah;

  const _SurahPageHeader({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Arabic Name
          Text(
            surah.nameArabic,
            style: const TextStyle(
              fontFamily: 'UthmanTaha',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),

          const SizedBox(height: 8),

          // English Name
          Text(
            surah.nameSimple,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 4),

          // Meaning
          Text(
            surah.translatedName.name,
            style: TextStyle(fontSize: 13, color: AppColors.grey500),
          ),

          const SizedBox(height: 12),

          // Info Chips
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              _InfoChip(
                label: surah.revelationPlace == 'makkah' ? 'Meccan' : 'Medinan',
              ),
              _InfoChip(label: '${surah.versesCount} Verses'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ============================================================================
// BISMILLAH
// ============================================================================

class _Bismillah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        style: TextStyle(
          fontFamily: 'UthmanTaha',
          fontSize: 22,
          fontWeight: FontWeight.w400,
          fontFeatures: const [FontFeature('liga', 1), FontFeature('clig', 1)],
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}

// ============================================================================
// PAGE INDICATOR
// Shows current page number like a book
// ============================================================================

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageIndicator({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$currentPage / $totalPages',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
