// import 'package:flutter/material.dart';
// import 'package:sukun/features/quran/models/surahs_model.dart';
// import 'package:sukun/features/quran/views/screens/surahreader_screen.dart';

// // ============================================================================
// // SURAH LIST (Al Munjiya Style)
// // ============================================================================

// class SurahList extends StatelessWidget {
//   final List<Chapter> surahs;

//   const SurahList({super.key, required this.surahs});

//   @override
//   Widget build(BuildContext context) {
//     if (surahs.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.menu_book, size: 64, color: Colors.grey.shade400),
//               const SizedBox(height: 16),
//               Text(
//                 'No Surahs available',
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: surahs.length,
//       separatorBuilder: (_, __) =>
//           Divider(height: 1, indent: 72, color: Colors.grey.shade300),
//       itemBuilder: (context, index) {
//         final surah = surahs[index];
//         return InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SurahReaderScreen(surahNumber: surah.id),
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               children: [
//                 // Number Badge (Al Munjiya style)
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2DA463).withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text(
//                       '${surah.id}',
//                       style: const TextStyle(
//                         color: Color(0xFF2DA463),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),

//                 // Surah Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         surah.nameSimple,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${surah.translatedName.name} • ${surah.versesCount} Verses',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Arabic Name
//                 Text(
//                   surah.nameArabic,
//                   style: const TextStyle(
//                     fontFamily: 'UthmanTaha',
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF2DA463),
//                   ),
//                   textDirection: TextDirection.rtl,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
