// import 'package:flutter/material.dart';
// import 'package:sukun/features/quran/models/juz_model.dart';
// import 'package:sukun/features/quran/models/surahs_model.dart';
// import 'package:sukun/features/quran/views/screens/juz_reader_screen.dart';

// // ============================================================================
// // JUZ LIST (Al Munjiya Style - Simple Grid)
// // ============================================================================

// class JuzList extends StatelessWidget {
//   final List<JuzElement> juz;
//   final List<Chapter> surahs;

//   const JuzList({super.key, required this.juz, required this.surahs});

//   @override
//   Widget build(BuildContext context) {
//     if (juz.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.book, size: 64, color: Colors.grey.shade400),
//               const SizedBox(height: 16),
//               Text(
//                 'No Juz data available',
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 1.2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//       ),
//       itemCount: juz.length,
//       itemBuilder: (context, index) {
//         final j = juz[index];
//         final firstVerse = j.verseMapping.entries.first;
//         final surah = _getSurahById(int.parse(firstVerse.key));

//         return InkWell(
//           onTap: () {
//             // Navigate to Juz reader
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     JuzReaderScreen(juzNumber: j.juzNumber, juzData: j),
//               ),
//             );
//           },
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   const Color(0xFF2DA463).withOpacity(0.8),
//                   const Color(0xFF2DA463),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF2DA463).withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Juz ${j.juzNumber}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 if (surah != null)
//                   Text(
//                     surah.nameArabic,
//                     style: const TextStyle(
//                       fontFamily: 'UthmanTaha',
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                     textDirection: TextDirection.rtl,
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Chapter? _getSurahById(int surahId) {
//     try {
//       return surahs.firstWhere(
//         (s) => s.id == surahId,
//         orElse: () => surahs.first,
//       );
//     } catch (e) {
//       return surahs.isNotEmpty ? surahs.first : null;
//     }
//   }
// }
