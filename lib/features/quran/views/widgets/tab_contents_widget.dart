// import 'package:flutter/material.dart';
// import 'package:sukun/features/quran/models/surahs_model.dart';
// import 'package:sukun/features/quran/view_models/quran_home_cubit/quran_home_state.dart';
// import 'package:sukun/features/quran/views/widgets/bookmark_list_widget.dart';
// import 'package:sukun/features/quran/views/widgets/juszlist_widget.dart';
// import 'package:sukun/features/quran/views/widgets/shurah_list._widget.dart';
// import 'package:sukun/features/quran/views/widgets/surahlist_widget.dart';

// //!  Tab Content
// class TabContent extends StatelessWidget {
//   final QuranHomeState state;
//   const TabContent({super.key, required this.state});

//   @override
//   Widget build(BuildContext context) {
//     // Always show content, even if state is not fully loaded
//     // Use data from state regardless of state type
//     final surahs = state.surahs.isNotEmpty ? state.surahs : <Chapter>[];
//     final juz = state.juz.isNotEmpty ? state.juz : [];
//     final bookmarks = state.bookmarks.isNotEmpty ? state.bookmarks : [];

//     // Wrap each tab in error boundary to prevent crashes
//     Widget buildTab(Widget child) {
//       return Builder(
//         builder: (context) {
//           try {
//             return child;
//           } catch (e, stackTrace) {
//             debugPrint('Error building tab content: $e');
//             debugPrint('Stack trace: $stackTrace');
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       size: 48,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Error loading content',
//                       style: TextStyle(color: Colors.grey.shade700),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       e.toString(),
//                       style: TextStyle(
//                         color: Colors.grey.shade500,
//                         fontSize: 12,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       );
//     }

//     // Show loading indicator only if data is completely empty and still loading
//     if (state.isLoading && surahs.isEmpty && juz.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(32.0),
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     switch (state.currentTabIndex) {
//       case 0:
//         return buildTab(SurahList(surahs: surahs));
//       case 1:
//         return buildTab(JuzList(juz: juz.cast(), surahs: surahs));
//       case 2:
//         return buildTab(BookmarkList(bookmarks: bookmarks.cast()));
//       default:
//         return buildTab(SurahList(surahs: surahs));
//     }
//   }
// }
