// import 'package:sukun/features/quran/models/bookmark_model.dart';
// import 'package:sukun/features/quran/models/juz_model.dart';
// import 'package:sukun/features/quran/models/reading_progress_model.dart';
// import 'package:sukun/features/quran/models/surahs_model.dart';

// class QuranHomeState {
//   final ReadingProgress? lastReading;
//   final List<Chapter> surahs;
//   final List<JuzElement> juz;
//   final List<Bookmark> bookmarks;
//   final bool isLoading;
//   final int currentTabIndex; // 0=Surah,1=Juz,2=Bookmarks
//   final String errors;
//   final Chapter? selectedSurah;
//   // final List<Verse>? verses;

//   QuranHomeState({
//     this.isLoading = true,
//     // this.verses,
//     this.lastReading,
//     this.surahs = const [],
//     this.juz = const [],
//     this.bookmarks = const [],
//     this.currentTabIndex = 0,
//     this.errors = '',
//     this.selectedSurah,
//   });

//   QuranHomeState copyWith({
//     ReadingProgress? lastReading,
//     List<Chapter>? surahs,
//     List<JuzElement>? juz,
//     List<Bookmark>? bookmarks,
//     bool? isLoading,
//     int? currentTabIndex,
//     String? errors,
//   }) {
//     return QuranHomeState(
//       lastReading: lastReading ?? this.lastReading,
//       surahs: surahs ?? this.surahs,
//       juz: juz ?? this.juz,
//       bookmarks: bookmarks ?? this.bookmarks,
//       isLoading: isLoading ?? this.isLoading,
//       currentTabIndex: currentTabIndex ?? this.currentTabIndex,
//       errors: errors ?? this.errors,
//     );
//   }
// }

// class QuranHomeInitial extends QuranHomeState {}

// class QuranHomeLoaded extends QuranHomeState {
//   QuranHomeLoaded({
//     super.lastReading,
//     required super.surahs,
//     required super.juz,
//     required super.bookmarks,
//   }) : super (isLoading: false);
// }

// class QuranHomeError extends QuranHomeState {
//   final String message;
//   QuranHomeError(this.message);
// }


// // SurahDetail states removed as they are now in surah_detail_state.dart



// ============================================================================
// QURAN HOME STATE
// ============================================================================

import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';

class QuranHomeState {
  final List<Chapter> surahs;
  final List<JuzElement> juz;
  final List<Bookmark> bookmarks;
  final int currentTab;
  final bool isLoading;
  final String error;

  QuranHomeState({
    this.surahs = const [],
    this.juz = const [],
    this.bookmarks = const [],
    this.currentTab = 0,
    this.isLoading = false,
    this.error = '',
  });

  QuranHomeState copyWith({
    List<Chapter>? surahs,
    List<JuzElement>? juz,
    List<Bookmark>? bookmarks,
    int? currentTab,
    bool? isLoading,
    String? error,
  }) {
    return QuranHomeState(
      surahs: surahs ?? this.surahs,
      juz: juz ?? this.juz,
      bookmarks: bookmarks ?? this.bookmarks,
      currentTab: currentTab ?? this.currentTab,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
