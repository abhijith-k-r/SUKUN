import 'package:flutter/material.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/views/widgets/ayah_card_widgets.dart';

class JuzReaderScreen extends StatelessWidget {
  final int juzNumber;
  final List<Ayah> verses;
  final List<Chapter> surahs;
  final List<Bookmark> bookmarks;
  final int? playingAyahNumber;
  final ScrollController scrollController;
  final Map<int, GlobalKey> ayahKeys;

  const JuzReaderScreen({super.key, 
    required this.juzNumber,
    required this.verses,
    required this.surahs,
    required this.bookmarks,
    required this.playingAyahNumber,
    required this.scrollController,
    required this.ayahKeys,
  });


  Chapter? _getSurahById(int surahId) {
    try {
      return surahs.firstWhere((s) => s.id == surahId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (verses.isEmpty) {
      return const Center(child: Text('No verses available'));
    }

    // Generate keys for each Ayah
    for (var ayah in verses) {
      final key = ayah.chapterId * 1000 + ayah.verseNumber;
      ayahKeys[key] = GlobalKey();
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: verses.length + 1, // +1 for header
      itemBuilder: (context, index) {
        // Juz Header
        if (index == 0) {
          return _JuzHeader(juzNumber: juzNumber, totalVerses: verses.length);
        }

        final ayah = verses[index - 1];
        final surah = _getSurahById(ayah.chapterId);

        // Check if Surah changes (show divider)
        final showSurahDivider =
            index == 1 ||
            (index > 1 && verses[index - 2].chapterId != ayah.chapterId);


        return Column(
          children: [
            if (showSurahDivider && surah != null) _SurahDivider(surah: surah),
           PageAyahCard(ayah: ayah, surahNumber: ayah.chapterId) 
          //  AyahCard(
          //     key: ayahKeys[keyIndex],
          //     ayah: ayah,
          //     surahNumber: ayah.chapterId,
          //     isBookmarked: isBookmarked,
          //     isPlaying: isPlaying,
          //   ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// JUZ HEADER
// ============================================================================

class _JuzHeader extends StatelessWidget {
  final int juzNumber;
  final int totalVerses;

  const _JuzHeader({required this.juzNumber, required this.totalVerses});

  String _getArabicNumber(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'جزء ${_getArabicNumber(juzNumber)}',
            style: const TextStyle(
              fontFamily: 'UthmanTaha',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            'Juz $juzNumber',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalVerses Verses',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SURAH DIVIDER
// Shows when Surah changes within Juz
// ============================================================================

class _SurahDivider extends StatelessWidget {
  final Chapter surah;

  const _SurahDivider({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '${surah.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah.nameSimple,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  surah.translatedName.name,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            surah.nameArabic,
            style: const TextStyle(fontFamily: 'UthmanTaha', fontSize: 16),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
