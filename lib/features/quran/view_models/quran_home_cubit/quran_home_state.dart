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
  final bool isSearchActive;
  final String searchQuery;
  final List<Chapter> searchResults;

  QuranHomeState({
    this.surahs = const [],
    this.juz = const [],
    this.bookmarks = const [],
    this.currentTab = 0,
    this.isLoading = false,
    this.error = '',
    this.isSearchActive = false,
    this.searchQuery = '',
    this.searchResults = const [],
  });

  QuranHomeState copyWith({
    List<Chapter>? surahs,
    List<JuzElement>? juz,
    List<Bookmark>? bookmarks,
    int? currentTab,
    bool? isLoading,
    String? error,
    bool? isSearchActive,
    String? searchQuery,
    List<Chapter>? searchResults,
  }) {
    return QuranHomeState(
      surahs: surahs ?? this.surahs,
      juz: juz ?? this.juz,
      bookmarks: bookmarks ?? this.bookmarks,
      currentTab: currentTab ?? this.currentTab,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
