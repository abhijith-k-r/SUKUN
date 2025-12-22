import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:sukun/features/quran/models/reading_progress_model.dart';
import 'package:sukun/features/quran/models/surah_model.dart';

class QuranHomeState {
  final ReadingProgress? lastReading;
  final List<Surah> surahs;
  final List<Juz> juz;
  final List<Bookmark> bookmarks;
  final bool loading;
  final int currentTabIndex; // 0=Surah,1=Juz,2=Bookmarks

  QuranHomeState({
    this.lastReading,
    this.surahs = const [],
    this.juz = const [],
    this.bookmarks = const [],
    this.loading = true,
    this.currentTabIndex = 0,
  });

  QuranHomeState copyWith({
    ReadingProgress? lastReading,
    List<Surah>? surahs,
    List<Juz>? juz,
    List<Bookmark>? bookmarks,
    bool? loading,
    int? currentTabIndex,
  }) {
    return QuranHomeState(
      lastReading: lastReading ?? this.lastReading,
      surahs: surahs ?? this.surahs,
      juz: juz ?? this.juz,
      bookmarks: bookmarks ?? this.bookmarks,
      loading: loading ?? this.loading,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}
