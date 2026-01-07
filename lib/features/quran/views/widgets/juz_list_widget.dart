// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sukun/core/theme/app_colors.dart';
// import 'package:sukun/core/services/quran_repository.dart';
// import 'package:sukun/features/quran/models/juz_model.dart';
// import 'package:sukun/features/quran/models/surahs_model.dart';
// import 'package:sukun/features/quran/views/screens/surah_reader_screen.dart';

// // ! =======(AGAIN ANOTHER SOMETHING) ========
// class JuzList extends StatefulWidget {
//   final List<JuzElement> juz;
//   final List<Chapter> surahs;
  
//   const JuzList({
//     super.key,
//     required this.juz,
//     required this.surahs,
//   });

//   @override
//   State<JuzList> createState() => _JuzListState();
// }

// class _JuzListState extends State<JuzList> {
//   final Map<int, List<Ayah>> _juzVerses = {};
//   final Map<int, bool> _loadingJuz = {};
//   final Map<int, bool> _expandedJuz = {};

//   Future<void> _loadJuzVerses(int juzNumber) async {
//     if (_juzVerses.containsKey(juzNumber) || 
//         _loadingJuz[juzNumber] == true) {
//       return;
//     }

//     setState(() {
//       _loadingJuz[juzNumber] = true;
//     });

//     try {
//       final quranRepo = context.read<QuranRepository>();
//       final verses = await quranRepo.getVersesByJuz(juzNumber);
      
//       if (mounted) {
//         setState(() {
//           _juzVerses[juzNumber] = verses;
//           _loadingJuz[juzNumber] = false;
//           _expandedJuz[juzNumber] = true;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error loading Juz $juzNumber verses: $e');
//       if (mounted) {
//         setState(() {
//           _loadingJuz[juzNumber] = false;
//         });
//       }
//     }
//   }

//   Chapter? _getSurahById(int surahId) {
//     try {
//       return widget.surahs.firstWhere(
//         (s) => s.id == surahId,
//         orElse: () => widget.surahs.first,
//       );
//     } catch (e) {
//       return widget.surahs.isNotEmpty ? widget.surahs.first : null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Always return a valid widget, even if empty
//     if (widget.juz.isEmpty) {
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
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Loading...',
//                 style: TextStyle(
//                   color: Colors.grey.shade500,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: widget.juz.length,
//       itemBuilder: (context, index) {
//         try {
//           final j = widget.juz[index];
//           final isExpanded = _expandedJuz[j.juzNumber] ?? false;
//           final verses = _juzVerses[j.juzNumber] ?? [];
//           final isLoading = _loadingJuz[j.juzNumber] ?? false;

//           // Auto-load first Juz verses on initial load
//           if (index == 0 && !isExpanded && !_juzVerses.containsKey(j.juzNumber) && !isLoading) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               _loadJuzVerses(j.juzNumber);
//             });
//           }
          
//           // Load verses when expanded
//           if (isExpanded && verses.isEmpty && !isLoading) {
//             _loadJuzVerses(j.juzNumber);
//           }

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Juz Header
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _expandedJuz[j.juzNumber] = !isExpanded;
//                     if (!isExpanded && !_juzVerses.containsKey(j.juzNumber)) {
//                       _loadJuzVerses(j.juzNumber);
//                     }
//                   });
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         isExpanded
//                             ? Icons.keyboard_arrow_down
//                             : Icons.keyboard_arrow_right,
//                         color: Colors.grey.shade600,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Juz ${j.juzNumber}',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Verses List
//               if (isExpanded)
//                 if (isLoading)
//                   const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   )
//                 else if (verses.isEmpty)
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       'No verses available',
//                       style: TextStyle(color: Colors.grey.shade600),
//                     ),
//                   )
//                 else
//                   ...verses.map((ayah) {
//                     final surah = _getSurahById(ayah.chapterId);
//                     final surahName = surah?.nameSimple ?? 'Unknown';
//                     final surahNameArabic = surah?.nameArabic ?? '';
                    
//                     return _JuzVerseItem(
//                       ayah: ayah,
//                       surahName: surahName,
//                       surahNameArabic: surahNameArabic,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SurahReaderScreen(
//                               surahNumber: ayah.chapterId,
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }),
//               const Divider(height: 1),
//             ],
//           );
//         } catch (e, stackTrace) {
//           debugPrint('Error building Juz list item at index $index: $e');
//           debugPrint('Stack trace: $stackTrace');
//           return ListTile(
//             leading: const Icon(Icons.error_outline, color: Colors.red),
//             title: const Text('Error loading item'),
//             subtitle: Text('Index: $index'),
//           );
//         }
//       },
//     );
//   }
// }

// class _JuzVerseItem extends StatelessWidget {
//   final Ayah ayah;
//   final String surahName;
//   final String surahNameArabic;
//   final VoidCallback onTap;

//   const _JuzVerseItem({
//     required this.ayah,
//     required this.surahName,
//     required this.surahNameArabic,
//     required this.onTap,
//   });

//   String _truncateText(String text, int maxLength) {
//     if (text.length <= maxLength) return text;
//     return '${text.substring(0, maxLength)}...';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Verse number badge
//             Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryGreen.withOpacity(0.1),
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: AppColors.primaryGreen.withOpacity(0.3),
//                   width: 1,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   '${ayah.verseNumber}',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryGreen,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // English translation
//                   Text(
//                     _truncateText(ayah.translation, 80),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                   // Surah name and Arabic
//                   Row(
//                     children: [
//                       Text(
//                         '$surahName - Ayah ${ayah.verseNumber}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       if (surahNameArabic.isNotEmpty)
//                         Text(
//                           surahNameArabic,
//                           style: const TextStyle(
//                             fontFamily: 'UthmanTaha',
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           textDirection: TextDirection.rtl,
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             // Right side number
//             Text(
//               '${ayah.verseNumber}',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
