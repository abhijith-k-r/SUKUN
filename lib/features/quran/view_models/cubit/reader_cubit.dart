import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/page_model.dart';
import 'package:sukun/features/quran/models/page_range_model.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/view_models/cubit/reader_state.dart';

class PageReaderCubit extends Cubit<PageReaderState> {
  final QuranRepository quranRepo;
  final UserQuranRepository userRepo;
  final String? userId;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Set<int> _pagesBeingLoaded = {};

  PageReaderCubit({
    required this.quranRepo,
    required this.userRepo,
    required this.userId,
  }) : super(PageReaderState()) {
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        debugPrint('✅ Audio finished - AUTO PLAYING NEXT AYAH');
        // 🔥 AUTO PLAY NEXT AYAH INSTEAD OF CLEARING
        Future.delayed(const Duration(milliseconds: 500), () async {
          if (!isClosed && this.state.playingAyahNumber != null) {
            playNextAyah();
          }
        });
      }
    });
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }


  PageRange getJuzPageRange(int juzNumber) {
    // ✅ CORRECT Juz page ranges based on standard Uthmani Quran (15-line Medinan Mushaf)
    // Same as used in JuzListTab
    const juzPageStarts = [
      1, 22, 42, 60, 82, 102, 121, 142, 162, 182, // Juz 1-10
      201, 222, 242, 262, 282, 302, 322, 342, 362, 382, // Juz 11-20
      402, 422, 442, 462, 482, 502, 522, 542, 562, 582, // Juz 21-30
    ];

    if (juzNumber < 1 || juzNumber > 30) {
      return PageRange(start: 1, end: 604);
    }

    final start = juzPageStarts[juzNumber - 1];
    final end = juzNumber < 30 ? juzPageStarts[juzNumber] - 1 : 604;

    return PageRange(start: start, end: end);
  }

  PageRange getSurahPageRange(int surahId) {
    const surahPageStarts = [
      1, 2, 50, 77, 106, 128, 151, 177, 187, 208, // Surah 1-10
      221, 235, 249, 255, 262, 267, 282, 293, 305, 312, // Surah 11-20
      322, 332, 342, 350, 359, 367, 377, 385, 396, 404, // Surah 21-30
      411, 415, 418, 428, 434, 440, 446, 453, 458, 467, // Surah 31-40
      477, 483, 489, 496, 499, 502, 507, 511, 515, 518, // Surah 41-50
      520, 523, 526, 528, 531, 534, 537, 542, 545, 549, // Surah 51-60
      551, 553, 554, 560, 562, 564, 566, 568, 570, 572, // Surah 61-70
      574, 577, 578, 580, 582, 583, 585, 586, 587, 587, // Surah 71-80
      589, 590, 591, 591, 592, 593, 594, 595, 595, 596, // Surah 81-90
      596, 597, 597, 598, 598, 599, 599, 600, 600, 601, // Surah 91-100
      601, 601, 602, 602, 602, 603, 603, 603, 604, 604, // Surah 101-110
      604, 604, 604, 604, // Surah 111-114
    ];

    if (surahId < 1 || surahId > 114) {
      return PageRange(start: 1, end: 604);
    }

    final start = surahPageStarts[surahId - 1];
    final end = surahId < 114 ? surahPageStarts[surahId] - 1 : 604;

    return PageRange(start: start, end: end);
  }

  int getJuzFromPage(int pageNumber) {
    const juzPageStarts = [
      1, 22, 42, 60, 82, 102, 121, 142, 162, 182, // Juz 1-10
      201, 222, 242, 262, 282, 302, 322, 342, 362, 382, // Juz 11-20
      402, 422, 442, 462, 482, 502, 522, 542, 562, 582, // Juz 21-30
    ];

    for (int i = 0; i < juzPageStarts.length; i++) {
      final startPage = juzPageStarts[i];
      final endPage = (i < juzPageStarts.length - 1)
          ? juzPageStarts[i + 1] - 1
          : 604;

      if (pageNumber >= startPage && pageNumber <= endPage) {
        return i + 1; 
      }
    }

    return 1; 
  }


  Future<void> loadQuranContent({int? initialJuz}) async {
    if (initialJuz == null) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      debugPrint('🔥 Loading Juz $initialJuz');

      final allSurahs = await quranRepo.getSurahs();
      final pageRange = getJuzPageRange(initialJuz);
      debugPrint(
        '🔥 Juz $initialJuz spans pages ${pageRange.start} to ${pageRange.end}',
      );

      final List<Future<QuranPage?>> pageFutures = [];
      for (int pageNum = pageRange.start; pageNum <= pageRange.end; pageNum++) {
        final actualJuz = getJuzFromPage(pageNum);
        pageFutures.add(_loadPage(pageNum, actualJuz, allSurahs));
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

      pages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
      debugPrint(
        '🔥 Successfully loaded ${pages.length} pages for Juz $initialJuz',
      );

      // ✅ Preload previous pages BEFORE emitting state for smooth backward navigation
      final List<QuranPage> allPagesToEmit = List<QuranPage>.from(pages);

      if (pages.isNotEmpty) {
        final firstPageNum = pages.first.pageNumber;
        final lastPageNum = pages.last.pageNumber;

        // ✅ Preload MORE previous pages (5 instead of 3) for smoother backward navigation
        for (int i = 1; i <= 5; i++) {
          final prevPageNum = firstPageNum - i;
          if (prevPageNum >= 1) {
            final prevPage = await _loadPage(
              prevPageNum,
              getJuzFromPage(prevPageNum),
              allSurahs,
            );
            if (prevPage != null) {
              allPagesToEmit.add(prevPage);
            }
          }
        }

        allPagesToEmit.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

        // Preload next page in background
        if (lastPageNum < 604) {
          _loadAndInsertPage(lastPageNum + 1);
        }
      }

      // ✅ Calculate correct starting index
      int startingPageIndex = 0;
      if (pages.isNotEmpty) {
        final targetPageNum = pages.first.pageNumber;
        startingPageIndex = allPagesToEmit.indexWhere(
          (p) => p.pageNumber == targetPageNum,
        );
        // Ensure starting index is valid
        if (startingPageIndex == -1) startingPageIndex = 0;
      }

      debugPrint(
        '📍 Juz $initialJuz: Starting at page ${pages.isNotEmpty ? pages.first.pageNumber : 0}, index: $startingPageIndex',
      );
      await _loadBookmarksAndEmit(allPagesToEmit, startingPageIndex);
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


  Future<void> loadAllSurahs({int? initialSurahNumber}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final surahId = initialSurahNumber ?? 1;
      debugPrint('🔥 Loading Surah $surahId');

      final allSurahs = await quranRepo.getSurahs();

      // ✅ LOGIC UPDATE: Use dynamic page range from API instead of hardcoded map
      // This ensures we land on the exact page the API uses for this Surah
      int starPage = 1;
      int endPage = 604;

      try {
        final targetSurah = allSurahs.firstWhere((s) => s.id == surahId);
        if (targetSurah.pages.isNotEmpty) {
          starPage = targetSurah.pages.first;
          endPage = targetSurah.pages.last;
          debugPrint('✅ Dynamic Surah Range: $starPage - $endPage from API');
        } else {
          // Fallback to hardcoded if API missing pages
          final range = getSurahPageRange(surahId);
          starPage = range.start;
          endPage = range.end;
        }
      } catch (e) {
        debugPrint('⚠️ Surah not found in list, using fallback');
        final range = getSurahPageRange(surahId);
        starPage = range.start;
        endPage = range.end;
      }

      final pageRange = PageRange(start: starPage, end: endPage);

      debugPrint(
        '🔥 Surah $surahId spans pages ${pageRange.start}-${pageRange.end}',
      );

      final pages = await _loadSurahPages(pageRange, allSurahs);

      if (pages.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'No pages for Surah $surahId',
          ),
        );
        return;
      }

      // ✅ Preload adjacent pages BEFORE emitting state for smooth navigation
      final List<QuranPage> allPagesToEmit = List<QuranPage>.from(pages);
      final firstPageNum = pages.first.pageNumber;
      final lastPageNum = pages.last.pageNumber;

      // Preload previous pages IMMEDIATELY (awaited) for backward navigation
      for (int i = 1; i <= 5; i++) {
        final prevPageNum = firstPageNum - i;
        if (prevPageNum >= 1) {
          final prevPage = await _loadPage(
            prevPageNum,
            getJuzFromPage(prevPageNum),
            allSurahs,
          );
          if (prevPage != null) {
            allPagesToEmit.add(prevPage);
          }
        }
      }

      // Sort all pages
      allPagesToEmit.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

      // Preload next page in background
      if (lastPageNum < 604) {
        _loadAndInsertPage(lastPageNum + 1);
      }

      final startingPageNum = pageRange.start;
      final startingIndex = allPagesToEmit.indexWhere(
        (p) => p.pageNumber == startingPageNum,
      );

      final finalStartingIndex = startingIndex >= 0 ? startingIndex : 0;

      debugPrint(
        '📍 Surah $surahId: Starting at page $startingPageNum, index: $finalStartingIndex',
      );
      debugPrint(
        '📄 Page numbers in list: ${allPagesToEmit.map((p) => p.pageNumber).toList()}',
      );

      await _loadBookmarksAndEmit(allPagesToEmit, finalStartingIndex);
      debugPrint(
        '✅ Surah $surahId loaded at page $startingPageNum, index $finalStartingIndex',
      );
    } catch (e) {
      debugPrint('❌ Surah load error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load Surah: $e',
        ),
      );
    }
  }

  Future<List<QuranPage>> _loadSurahPages(
    PageRange range,
    List<Chapter> allSurahs,
  ) async {
    final futures = <Future<QuranPage?>>[];
    for (int pageNum = range.start; pageNum <= range.end; pageNum++) {
      futures.add(_loadPage(pageNum, getJuzFromPage(pageNum), allSurahs));
    }

    final results = await Future.wait(futures);
    return results.whereType<QuranPage>().toList()
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
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
        debugPrint(
          '✅ Loaded page $pageNum (Juz $juzNumber) with ${verses.length} verses',
        );
        return page;
      }
    } catch (e) {
      debugPrint('❌ Failed to load page $pageNum: $e');
    }
    return null;
  }

  Future<void> _loadBookmarksAndEmit(
    List<QuranPage> pages,
    int startingPageIndex,
  ) async {
    if (userId != null) {
      try {
        final bookmarks = await userRepo.getBookmarks(userId!);
        final bookmarkedIds = bookmarks.map((b) => b.ayahNumber).toSet();
        if (isClosed) return;

        final sortedPages = List<QuranPage>.from(pages)
          ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
        debugPrint(
          '📚 Emitting ${sortedPages.length} pages, starting at index $startingPageIndex',
        );

        emit(
          state.copyWith(
            allPages: sortedPages,
            currentPageIndex: startingPageIndex,
            isLoading: false,
            bookmarkedAyahs: bookmarkedIds,
          ),
        );
      } catch (e) {
        debugPrint('Failed to load bookmarks: $e');
        if (isClosed) return;
        final sortedPages = List<QuranPage>.from(pages)
          ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
        emit(
          state.copyWith(
            allPages: sortedPages,
            currentPageIndex: startingPageIndex,
            isLoading: false,
          ),
        );
      }
    } else {
      final sortedPages = List<QuranPage>.from(pages)
        ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
      emit(
        state.copyWith(
          allPages: sortedPages,
          currentPageIndex: startingPageIndex,
          isLoading: false,
        ),
      );
    }
  }

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
            pageNumber: 0,
            juzNumber: 0,
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

  bool isBookmarked(int ayahNumber) =>
      state.bookmarkedAyahs.contains(ayahNumber);


  void onPageChanged(int pageIndex) {
    if (pageIndex < 0) return;

    if (pageIndex < state.allPages.length) {
      emit(state.copyWith(currentPageIndex: pageIndex));
    } else if (state.allPages.isNotEmpty) {
      final clampedIndex = pageIndex.clamp(0, state.allPages.length - 1);
      emit(state.copyWith(currentPageIndex: clampedIndex));
    }

    _loadAdjacentPagesIfNeeded(pageIndex);
  }

  Future<void> _loadAdjacentPagesIfNeeded(int currentIndex) async {
    if (state.allPages.isEmpty) return;

    if (currentIndex >= state.allPages.length) {
      currentIndex = state.allPages.length - 1;
    }
    if (currentIndex < 0) return;

    final currentPage = state.allPages[currentIndex];
    final currentPageNum = currentPage.pageNumber;

    // ✅ Load next pages (forward navigation) - background loading
    for (int offset = 1; offset <= 3; offset++) {
      final nextPageNum = currentPageNum + offset;
      if (nextPageNum <= 604) {
        final hasPage = state.allPages.any((p) => p.pageNumber == nextPageNum);
        if (!hasPage) {
          _loadAndInsertPage(nextPageNum); // Don't await - load in background
        }
      }
    }
    int loadedCount = 0;
    for (int offset = 1; offset <= 10; offset++) {
      final prevPageNum = currentPageNum - offset;
      if (prevPageNum >= 1) {
        final hasPage = state.allPages.any((p) => p.pageNumber == prevPageNum);
        if (!hasPage) {
          if (loadedCount < 5) {
            await _loadAndInsertPage(prevPageNum);
            loadedCount++;
          } else {
            _loadAndInsertPage(prevPageNum); 
          }
        }
      }
    }
  }

  Future<void> _loadAndInsertPage(int pageNum) async {
    try {
      if (state.allPages.any((p) => p.pageNumber == pageNum)) {
        return;
      }

      if (_pagesBeingLoaded.contains(pageNum)) {
        return;
      }

      _pagesBeingLoaded.add(pageNum);

      final allSurahs = await quranRepo.getSurahs();
      final verses = await quranRepo.getVersesByPage(pageNum);
      if (verses.isEmpty) return;

      final juzNumber = getJuzFromPage(pageNum);
      final newPage = QuranPage.fromAyahs(
        pageNumber: pageNum,
        ayahs: verses,
        juzNumber: juzNumber,
        allSurahs: allSurahs,
      );

      final updatedPages = List<QuranPage>.from(state.allPages);
      updatedPages.add(newPage);
      updatedPages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

      final uniquePages = <int, QuranPage>{};
      for (final page in updatedPages) {
        uniquePages[page.pageNumber] = page;
      }
      final finalPages = uniquePages.values.toList()
        ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

      if (isClosed) return;

      int newPageIndex = state.currentPageIndex;

      if (state.allPages.isNotEmpty) {
        final currentPageNum =
            state.allPages[state.currentPageIndex].pageNumber;
        final newIndex = finalPages.indexWhere(
          (p) => p.pageNumber == currentPageNum,
        );
        if (newIndex != -1) {
          newPageIndex = newIndex;
        }
      }

      if (!isClosed) {
        emit(
          state.copyWith(allPages: finalPages, currentPageIndex: newPageIndex),
        );
      }

      debugPrint(
        '✅ Loaded page $pageNum (Juz $juzNumber), total pages: ${finalPages.length}. Index adjusted to $newPageIndex',
      );
    } catch (e) {
      debugPrint('❌ Failed to load page $pageNum: $e');
    } finally {
      _pagesBeingLoaded.remove(pageNum);
    }
  }


  bool isPlaying(int ayahNumber) => state.playingAyahNumber == ayahNumber;

  void setPlayingAyah(int surahNumber, int ayahNumber) {
    debugPrint('🎵 Play: Surah $surahNumber Ayah $ayahNumber');
    emit(
      state.copyWith(
        playingSurahNumber: surahNumber,
        playingAyahNumber: ayahNumber,
      ),
    );
    _playAyah(surahNumber, ayahNumber);
  }

  Future<void> _playAyah(int surahNumber, int ayahNumber) async {
    if (state.allPages.isEmpty) {
      debugPrint('⚠️ No pages loaded, waiting...');
      for (int i = 0; i < 50; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        if (state.allPages.isNotEmpty) break;
      }
      if (state.allPages.isEmpty) {
        debugPrint('❌ Still no pages after waiting');
        if (!isClosed) {
          emit(
            state.copyWith(playingAyahNumber: null, playingSurahNumber: null),
          );
        }
        return;
      }
    }

    debugPrint(
      '🔍 Searching for ayah: Surah $surahNumber, Ayah $ayahNumber in ${state.allPages.length} pages',
    );

    AyahData? ayahData = _findAyahFast(surahNumber, ayahNumber);

    if (ayahData == null) {
      debugPrint(
        '🔄 Ayah $surahNumber:$ayahNumber not found in loaded pages, loading nearby pages...',
      );
      debugPrint(
        '📄 Loaded pages: ${state.allPages.map((p) => p.pageNumber).toList()}',
      );
      await _loadPageForAyah(surahNumber, ayahNumber);
      ayahData = _findAyahFast(surahNumber, ayahNumber);
      if (ayahData == null) {
        debugPrint(
          '❌ Ayah $surahNumber:$ayahNumber still not found after loading nearby pages',
        );
        if (!isClosed) {
          emit(
            state.copyWith(playingAyahNumber: null, playingSurahNumber: null),
          );
        }
        return;
      }
    }

    await _playAudio(ayahData);
  }

  AyahData? _findAyahFast(int surahNumber, int ayahNumber) {
    for (final page in state.allPages) {
      for (final ayah in page.ayahs) {
        if (ayah.surahNumber == surahNumber && ayah.ayahNumber == ayahNumber) {
          debugPrint(
            '✅ Ayah $surahNumber:$ayahNumber found on page ${page.pageNumber}',
          );
          return ayah;
        }
      }
    }
    return null;
  }

  Future<void> _loadPageForAyah(int surahNumber, int ayahNumber) async {
    // ✅ Use current page if available, otherwise start from page 1
    final currentPageNum =
        state.allPages.isNotEmpty &&
            state.currentPageIndex < state.allPages.length
        ? state.allPages[state.currentPageIndex].pageNumber
        : (state.allPages.isNotEmpty ? state.allPages.first.pageNumber : 1);

    // ✅ Load pages around current page to find the ayah
    for (int offset = -10; offset <= 20; offset++) {
      final targetPage = (currentPageNum + offset).clamp(1, 604);
      final hasPage = state.allPages.any((p) => p.pageNumber == targetPage);

      if (!hasPage) {
        await _loadAndInsertPage(targetPage);
        // Check if ayah found after loading
        if (_findAyahFast(surahNumber, ayahNumber) != null) {
          debugPrint('✅ Found ayah after loading page $targetPage');
          return;
        }
      } else {
        // Page already loaded, check if ayah is in it
        if (_findAyahFast(surahNumber, ayahNumber) != null) {
          return;
        }
      }
    }
  }

  Future<void> _playAudio(AyahData ayah) async {
    final surahStr = ayah.surahNumber.toString().padLeft(3, "0");
    final ayahStr = ayah.ayahNumberInSurah.toString().padLeft(3, "0");

    final urls = [
      'https://mirrors.quranicaudio.com/everyayah/Alafasy_128kbps/$surahStr$ayahStr.mp3',
      'https://everyayah.com/data2/audio/128/kids/$surahStr$ayahStr.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$ayah.ayahNumber.mp3',
    ];

    // ✅ Ensure volume is up
    await _audioPlayer.setVolume(1.0);

    for (final url in urls) {
      try {
        debugPrint('🎵 Trying: $url');
        await _audioPlayer.stop();
        await _audioPlayer.setUrl(url);
        await _audioPlayer.play();
        debugPrint('✅ 🎵 PLAYING: $url');
        return;
      } catch (e) {
        debugPrint('❌ URL failed: $e');
      }
    }

    // Try a few more standard backup URLs if above fail
    try {
      final stdUrl =
          'https://verses.quran.com/Alafasy/mp3/$surahStr$ayahStr.mp3';
      debugPrint('🎵 Trying backup: $stdUrl');
      await _audioPlayer.setUrl(stdUrl);
      await _audioPlayer.play();
      debugPrint('✅ 🎵 PLAYING BACKUP: $stdUrl');
      return;
    } catch (e) {
      debugPrint('❌ Backup URL failed: $e');
    }

    debugPrint('❌ All audio URLs failed');
    emit(state.copyWith(playingAyahNumber: null, playingSurahNumber: null));
  }

  // 🔥 NEW: Play Next Ayah (Auto Sequential Playback)
  void playNextAyah() {
    final currentAyahData = _findCurrentAyah();
    if (currentAyahData == null) {
      debugPrint('❌ No current ayah found');
      return;
    }

    final nextAyah = _getNextAyah(currentAyahData);
    if (nextAyah != null) {
      debugPrint(
        '⏭️ Playing next: Surah ${nextAyah.surahNumber} Ayah ${nextAyah.ayahNumber}',
      );
      setPlayingAyah(nextAyah.surahNumber, nextAyah.ayahNumber);
    } else {
      debugPrint('✅ End of pages reached');
      stopPlayback();
    }
  }

  AyahData? _findCurrentAyah() {
    final surah = state.playingSurahNumber;
    final ayah = state.playingAyahNumber;
    if (surah == null || ayah == null) return null;

    return _findAyahFast(surah, ayah);
  }

  AyahData? _getNextAyah(AyahData currentAyah) {
    // Search through all loaded pages for next ayah
    for (final page in state.allPages) {
      final ayahIndex = page.ayahs.indexWhere(
        (ayah) =>
            ayah.surahNumber == currentAyah.surahNumber &&
            ayah.ayahNumber == currentAyah.ayahNumber,
      );

      if (ayahIndex != -1) {
        // Next ayah on same page
        if (ayahIndex < page.ayahs.length - 1) {
          return page.ayahs[ayahIndex + 1];
        }

        // First ayah of next page
        final pageIndex = state.allPages.indexOf(page);
        if (pageIndex < state.allPages.length - 1) {
          final nextPage = state.allPages[pageIndex + 1];
          if (nextPage.ayahs.isNotEmpty) {
            return nextPage.ayahs.first;
          }
        }
        return null;
      }
    }
    return null;
  }

  void stopPlayback() {
    _audioPlayer.stop();
    // ✅ CRITICAL: Ensure all playing states are cleared to remove the card
    emit(state.copyWith(clearAudioState: true));
    debugPrint('⏹️ Stopped playback - Card should disappear');
  }

  void pauseAudio() {
    _audioPlayer.pause();
    emit(state.copyWith(isAudioPaused: true));
    debugPrint('⏸️ Paused playback');
  }

  void resumeAudio() {
    _audioPlayer.play();
    emit(state.copyWith(isAudioPaused: false));
    debugPrint('▶️ Resumed playback');
  }
}

// ✅ FIXED: Proper generic extension with null safety
extension ListFirstWhereOrNullExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
