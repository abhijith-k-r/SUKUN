// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sukun/core/services/quran_repository.dart';
// import 'package:sukun/features/quran/view_models/juz_reader_cubit/juz_reader_state.dart';

// class JuzReaderCubit extends Cubit<JuzReaderState> {
//   final QuranRepository quranRepo;
//   final UserQuranRepository userRepo;
//   // final String? userId;

//   JuzReaderCubit({
//     required this.quranRepo,
//     required this.userRepo,
//     // required this.userId,
//   }) : super(JuzReaderLoading());

//   Future<void> loadJuz(int juzNumber) async {
//     emit(JuzReaderLoading());
//     try {
//       final verses = await quranRepo.getVersesByJuz(juzNumber);
//       final surahs = await quranRepo.getSurahs();

//       // Load bookmarks
//       List<String> bookmarkedKeys = [];
//       // if (userId != null) {
//       //   try {
//       //     final bookmarks = await userRepo.getBookmarks(userId!);
//       //     bookmarkedKeys = bookmarks
//       //         .map((b) => '${b.surahNumber}-${b.ayahNumber}')
//       //         .toList();
//       //   } catch (e) {
//       //     debugPrint('Error loading bookmarks: $e');
//       //   }
//       // }

//       emit(
//         JuzReaderLoaded(
//           juzNumber: juzNumber,
//           verses: verses,
//           surahs: surahs,
//           bookmarkedKeys: bookmarkedKeys,
//         ),
//       );
//     } catch (e) {
//       emit(JuzReaderError(e.toString()));
//     }
//   }

//   Future<void> toggleBookmark(int surahNumber, int ayahNumber) async {
//     if (state is! JuzReaderLoaded 
//     // || userId == null
//     ) return;

//     final currentState = state as JuzReaderLoaded;
//     final key = '$surahNumber-$ayahNumber';
//     final bookmarked = List<String>.from(currentState.bookmarkedKeys);

//     if (bookmarked.contains(key)) {
//       bookmarked.remove(key);
//       try {
//         // await userRepo.removeBookmark(userId!, surahNumber, ayahNumber);
//       } catch (e) {
//         debugPrint('Error removing bookmark: $e');
//       }
//     } else {
//       bookmarked.add(key);
//       try {
//         // await userRepo.addBookmark(userId!, surahNumber, ayahNumber);
//       } catch (e) {
//         debugPrint('Error adding bookmark: $e');
//       }
//     }

//     emit(
//       JuzReaderLoaded(
//         juzNumber: currentState.juzNumber,
//         verses: currentState.verses,
//         surahs: currentState.surahs,
//         bookmarkedKeys: bookmarked,
//       ),
//     );
//   }
// }
