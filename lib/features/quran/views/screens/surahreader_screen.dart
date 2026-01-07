// import 'package:flutter/material.dart';
// import 'package:sukun/features/quran/models/bookmark_model.dart';
// import 'dart:ui';

// import 'package:sukun/features/quran/models/surahs_model.dart';
// import 'package:sukun/features/quran/views/widgets/ayah_card_widgets.dart';

// // ============================================================================
// // SURAH READER
// // Displays Surah content with smooth scrolling
// // ============================================================================

// class SurahReaderScreen extends StatelessWidget {
//   final Chapter surah;
//   final List<Bookmark> bookmarks;
//   final int? playingAyahNumber;
//   final ScrollController scrollController;
//   final Map<int, GlobalKey> ayahKeys;

//   const SurahReaderScreen({
//     required this.surah,
//     required this.bookmarks,
//     required this.playingAyahNumber,
//     required this.scrollController,
//     required this.ayahKeys,
//   });

//   bool _isBookmarked(int ayahNumber) {
//     return bookmarks.any(
//       (b) => b.surahNumber == surah.id && b.ayahNumber == ayahNumber,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Generate keys for each Ayah for scrolling
//     for (var ayah in surah.verses) {
//       ayahKeys[ayah.verseNumber] = GlobalKey();
//     }

//     return ListView.builder(
//       controller: scrollController,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       itemCount: surah.verses.length + 1, // +1 for header
//       itemBuilder: (context, index) {
//         // Surah Header
//         if (index == 0) {
//           return _SurahHeader(surah: surah);
//         }

//         // Ayah
//         final ayah = surah.verses[index - 1];
//         final isBookmarked = _isBookmarked(ayah.verseNumber);
//         final isPlaying = playingAyahNumber == ayah.verseNumber;

//         return AyahCard(
//           key: ayahKeys[ayah.verseNumber],
//           ayah: ayah,
//           surahNumber: surah.id,
//           isBookmarked: isBookmarked,
//           isPlaying: isPlaying,
//         );
//       },
//     );
//   }
// }

// // ============================================================================
// // SURAH HEADER
// // Shows Surah info at the top
// // ============================================================================

// class _SurahHeader extends StatelessWidget {
//   final Chapter surah;

//   const _SurahHeader({required this.surah});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey[300]!),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           // Arabic Name
//           Text(
//             surah.nameArabic,
//             style: const TextStyle(
//               fontFamily: 'UthmanTaha',
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//             ),
//             textDirection: TextDirection.rtl,
//           ),
//           const SizedBox(height: 8),

//           // English Name
//           Text(
//             surah.nameSimple,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 4),

//           // Meaning
//           Text(
//             surah.translatedName.name,
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 12),

//           // Info Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _InfoChip(
//                 label: surah.revelationPlace == 'makkah' ? 'Meccan' : 'Medinan',
//               ),
//               const SizedBox(width: 8),
//               _InfoChip(label: '${surah.versesCount} Verses'),
//             ],
//           ),

//           // Bismillah (skip for Surah 1 and 9)
//           if (surah.id != 1 && surah.id != 9) ...[
//             const SizedBox(height: 20),
//             const Divider(),
//             const SizedBox(height: 20),
//             Text(
//               'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
//               style: TextStyle(
//                 fontFamily: 'UthmanTaha',
//                 fontSize: 24,
//                 fontWeight: FontWeight.w400,
//                 fontFeatures: const [
//                   FontFeature('liga', 1),
//                   FontFeature('clig', 1),
//                 ],
//               ),
//               textAlign: TextAlign.center,
//               textDirection: TextDirection.rtl,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class _InfoChip extends StatelessWidget {
//   final String label;

//   const _InfoChip({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         label,
//         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
// }
