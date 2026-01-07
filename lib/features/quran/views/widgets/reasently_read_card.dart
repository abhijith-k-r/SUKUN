// import 'package:flutter/material.dart';
// import 'package:sukun/features/quran/models/reading_progress_model.dart';

// // ============================================================================
// // RECENTLY READ CARD
// // ============================================================================

// class RecentlyReadCard extends StatelessWidget {
//   final ReadingProgress? progress;

//   const RecentlyReadCard({super.key, required this.progress});

//   @override
//   Widget build(BuildContext context) {
//     if (progress == null) {
//       return const SizedBox.shrink();
//     }

//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF2DA463), Color(0xFF1E8B4D)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF2DA463).withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.menu_book,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Last Read',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           Text(
//             'Al-Fatihah', // TODO: Map from progress.surahNumber
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Ayah ${progress!.ayahNumber}',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 14,
//             ),
//           ),

//           const SizedBox(height: 16),

//           Row(
//             children: [
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(4),
//                   child: LinearProgressIndicator(
//                     value: progress!.percentage,
//                     minHeight: 6,
//                     backgroundColor: Colors.white.withOpacity(0.3),
//                     valueColor: const AlwaysStoppedAnimation<Color>(
//                       Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 '${(progress!.percentage * 100).round()}%',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           ElevatedButton(
//             onPressed: () {
//               // TODO: Navigate to reading screen at saved surah/ayah
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: const Color(0xFF2DA463),
//               minimumSize: const Size(double.infinity, 44),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               elevation: 0,
//             ),
//             child: const Text(
//               'Continue Reading',
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
