import 'package:sukun/features/quran/models/page_model.dart';

enum ReaderMode { surah, juz, page }

class PageReaderState {
  final List<QuranPage> allPages;
  final int currentPageIndex;
  final bool isLoading;
  final String? errorMessage;
  final Set<int> bookmarkedAyahs;
  final int? playingSurahNumber;
  final int? playingAyahNumber;

  PageReaderState({
    this.allPages = const [],
    this.currentPageIndex = 0,
    this.isLoading = false,
    this.errorMessage,
    this.bookmarkedAyahs = const {},
    this.playingSurahNumber,
    this.playingAyahNumber,
  });

  PageReaderState copyWith({
    List<QuranPage>? allPages,
    int? currentPageIndex,
    bool? isLoading,
    String? errorMessage,
    Set<int>? bookmarkedAyahs,
    int? playingSurahNumber,
    int? playingAyahNumber,
  }) {
    return PageReaderState(
      allPages: allPages ?? this.allPages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      bookmarkedAyahs: bookmarkedAyahs ?? this.bookmarkedAyahs,
      playingSurahNumber: playingSurahNumber ?? this.playingSurahNumber,
      playingAyahNumber: playingAyahNumber ?? this.playingAyahNumber,
    );
  }
}
