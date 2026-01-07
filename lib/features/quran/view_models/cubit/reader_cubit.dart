import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:sukun/features/quran/models/page_model.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/view_models/cubit/reader_state.dart';

// ============================================================================
// IMPROVED PAGE READER CUBIT - PAGE-BY-PAGE LOADING
// ============================================================================

class PageReaderCubit extends Cubit<PageReaderState> {
  final QuranRepository quranRepo;
  final UserQuranRepository userRepo;
  final String? userId;

  PageReaderCubit({
    required this.quranRepo,
    required this.userRepo,
    required this.userId,
  }) : super(PageReaderState());

  // ============================================================================
  // LOAD QURAN BY JUZ - IMPROVED VERSION
  // ============================================================================

  Future<void> loadQuranContent({int? initialJuz}) async {
    if (initialJuz == null) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      debugPrint('🔥 Loading Juz $initialJuz');

      // Load surahs for name mapping
      final allSurahs = await quranRepo.getSurahs();

      // Get page range for this Juz
      final pageRange = _getJuzPageRange(initialJuz);
      debugPrint(
        '🔥 Juz $initialJuz spans pages ${pageRange.start} to ${pageRange.end}',
      );

      // Load all pages in this Juz in parallel
      final List<Future<QuranPage?>> pageFutures = [];
      for (int pageNum = pageRange.start; pageNum <= pageRange.end; pageNum++) {
        pageFutures.add(_loadPage(pageNum, initialJuz, allSurahs));
      }

      final pageResults = await Future.wait(pageFutures);
      final pages = pageResults.whereType<QuranPage>().toList();

      if (pages.isEmpty) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'No pages found for Juz $initialJuz',
          ),
        );
        return;
      }

      // Sort pages
      pages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

      debugPrint(
        '🔥 Successfully loaded ${pages.length} pages for Juz $initialJuz',
      );

      // Load bookmarks
      await _loadBookmarksAndEmit(pages);
    } catch (e) {
      debugPrint('🔥 Error loading Juz: $e');
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load Juz: $e',
        ),
      );
    }
  }

  Future<QuranPage?> _loadPage(
    int pageNum,
    int juzNumber,
    List<Chapter> allSurahs,
  ) async {
    try {
      final verses = await quranRepo.getVersesByPage(pageNum);
      if (verses.isNotEmpty) {
        final page = QuranPage.fromAyahs(
          pageNumber: pageNum,
          ayahs: verses,
          juzNumber: juzNumber,
          allSurahs: allSurahs,
        );
        debugPrint('✅ Loaded page $pageNum with ${verses.length} verses');
        return page;
      }
    } catch (e) {
      debugPrint('❌ Failed to load page $pageNum: $e');
    }
    return null;
  }

  // Get page range for a Juz
  PageRange _getJuzPageRange(int juzNumber) {
    const juzPageStarts = [
      1,
      22,
      42,
      60,
      82,
      102,
      121,
      142,
      162,
      182,
      201,
      222,
      242,
      262,
      282,
      302,
      322,
      342,
      362,
      382,
      402,
      422,
      442,
      462,
      482,
      502,
      522,
      542,
      562,
      582,
    ];

    final start = juzPageStarts[juzNumber - 1];
    final end = juzNumber < 30 ? juzPageStarts[juzNumber] - 1 : 604;

    return PageRange(start: start, end: end);
  }

  // ============================================================================
  // LOAD QURAN BY SURAH - IMPROVED VERSION
  // ============================================================================

  Future<void> loadAllSurahs({int? initialSurahNumber}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final surahId = initialSurahNumber ?? 1;
      debugPrint('🔥 Loading Surah $surahId');

      // Load surahs for name mapping
      final allSurahs = await quranRepo.getSurahs();

      // Get page range for this Surah
      final pageRange = _getSurahPageRange(surahId);
      debugPrint(
        '🔥 Surah $surahId spans pages ${pageRange.start} to ${pageRange.end}',
      );

      // Load all pages in this Surah in parallel
      final List<Future<QuranPage?>> pageFutures = [];
      for (int pageNum = pageRange.start; pageNum <= pageRange.end; pageNum++) {
        pageFutures.add(_loadSurahPage(pageNum, surahId, allSurahs));
      }

      final pageResults = await Future.wait(pageFutures);
      final pages = pageResults.whereType<QuranPage>().toList();

      if (pages.isEmpty) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'No pages found for Surah $surahId',
          ),
        );
        return;
      }

      pages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

      debugPrint(
        '🔥 Successfully loaded ${pages.length} pages for Surah $surahId',
      );

      await _loadBookmarksAndEmit(pages);
    } catch (e) {
      debugPrint('🔥 Error loading Surah: $e');
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load Surah: $e',
        ),
      );
    }
  }

  Future<QuranPage?> _loadSurahPage(
    int pageNum,
    int surahId,
    List<Chapter> allSurahs,
  ) async {
    try {
      final verses = await quranRepo.getVersesByPage(pageNum);
      // Filter verses for this specific Surah only
      final surahVerses = verses.where((v) => v.chapterId == surahId).toList();

      if (surahVerses.isNotEmpty) {
        final page = QuranPage.fromAyahs(
          pageNumber: pageNum,
          ayahs: surahVerses,
          juzNumber: _getSurahJuz(surahId, await quranRepo.getJuzList()),
          allSurahs: allSurahs,
        );
        debugPrint(
          '✅ Loaded page $pageNum with ${surahVerses.length} verses from Surah $surahId',
        );
        return page;
      }
    } catch (e) {
      debugPrint('❌ Failed to load page $pageNum: $e');
    }
    return null;
  }

  // Get page range for a Surah
  PageRange _getSurahPageRange(int surahId) {
    const surahPageStarts = [
      1,
      2,
      50,
      77,
      106,
      128,
      151,
      177,
      187,
      208,
      221,
      235,
      249,
      255,
      262,
      267,
      282,
      293,
      305,
      312,
      322,
      332,
      342,
      350,
      359,
      367,
      377,
      385,
      396,
      404,
      411,
      415,
      418,
      428,
      434,
      440,
      446,
      453,
      458,
      467,
      477,
      483,
      489,
      496,
      499,
      502,
      507,
      511,
      515,
      518,
      520,
      523,
      526,
      528,
      531,
      534,
      537,
      542,
      545,
      549,
      551,
      553,
      554,
      560,
      562,
      564,
      566,
      568,
      570,
      572,
      574,
      577,
      578,
      580,
      582,
      583,
      585,
      586,
      587,
      587,
      589,
      590,
      591,
      591,
      592,
      593,
      594,
      595,
      595,
      596,
      596,
      597,
      597,
      598,
      598,
      599,
      599,
      600,
      600,
      601,
      601,
      601,
      602,
      602,
      602,
      603,
      603,
      603,
      604,
      604,
      604,
    ];

    final start = surahPageStarts[surahId - 1];
    final end = surahId < 114 ? surahPageStarts[surahId] - 1 : 604;

    return PageRange(start: start, end: end);
  }

  int _getSurahJuz(int surahId, List<JuzElement> juzList) {
    // Find which juz contains this surah
    // This is a simplified implementation - in a real app you'd map surah pages to juz
    // For now, return a default juz
    return 1;
  }

  Future<void> _loadBookmarksAndEmit(List<QuranPage> pages) async {
    if (userId != null) {
      try {
        final bookmarks = await userRepo.getBookmarks(userId!);
        final bookmarkedIds = bookmarks.map((b) => b.ayahNumber).toSet();
        if (isClosed) return;
        emit(
          state.copyWith(
            allPages: pages,
            currentPageIndex: 0,
            isLoading: false,
            bookmarkedAyahs: bookmarkedIds,
          ),
        );
      } catch (e) {
        debugPrint('Failed to load bookmarks: $e');
        if (isClosed) return;
        emit(
          state.copyWith(
            allPages: pages,
            currentPageIndex: 0,
            isLoading: false,
          ),
        );
      }
    } else {
      if (isClosed) return;
      emit(
        state.copyWith(allPages: pages, currentPageIndex: 0, isLoading: false),
      );
    }
  }

  // ============================================================================
  // PAGE NAVIGATION
  // ============================================================================

  void onPageChanged(int pageIndex) {
    if (pageIndex < 0 || pageIndex >= state.allPages.length) return;
    emit(state.copyWith(currentPageIndex: pageIndex));
  }

  // ============================================================================
  // BOOKMARKS
  // ============================================================================

  Future<void> toggleBookmark(
    int ayahNumber,
    int surahNumber,
    int ayahNumberInSurah,
    String surahName,
    String ayahText,
  ) async {
    if (userId == null) {
      debugPrint('User not logged in - cannot bookmark');
      return;
    }

    final newBookmarks = Set<int>.from(state.bookmarkedAyahs);

    if (newBookmarks.contains(ayahNumber)) {
      newBookmarks.remove(ayahNumber);
      debugPrint('Removed bookmark for ayah $ayahNumber');
    } else {
      newBookmarks.add(ayahNumber);
      debugPrint('Added bookmark for ayah $ayahNumber');

      try {
        await userRepo.addBookmark(
          userId!,
          Bookmark(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: userId!,
            ayahNumber: ayahNumber,
            ayahNumberInSurah: ayahNumberInSurah,
            surahNumber: surahNumber,
            surahName: surahName,
            pageNumber: 0, // Not available
            juzNumber: 0, // Not available
            ayahText: ayahText,
            createdAt: DateTime.now(),
          ),
        );
      } catch (e) {
        debugPrint('Failed to save bookmark: $e');
      }
    }

    emit(state.copyWith(bookmarkedAyahs: newBookmarks));
  }

  bool isBookmarked(int ayahNumber) {
    return state.bookmarkedAyahs.contains(ayahNumber);
  }

  // ============================================================================
  // AUDIO PLAYBACK
  // ============================================================================

  bool isPlaying(int ayahNumber) {
    return state.playingAyahNumber == ayahNumber;
  }

  void setPlayingAyah(int surahNumber, int ayahNumber) {
    emit(
      state.copyWith(
        playingSurahNumber: surahNumber,
        playingAyahNumber: ayahNumber,
      ),
    );
  }

  void stopPlayback() {
    emit(state.copyWith(playingAyahNumber: null));
    debugPrint('Stopped playback');
  }
}

// ============================================================================
// HELPER CLASS
// ============================================================================

class PageRange {
  final int start;
  final int end;

  PageRange({required this.start, required this.end});
}
