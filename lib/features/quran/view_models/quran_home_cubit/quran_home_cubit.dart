import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/view_models/quran_home_cubit/quran_home_state.dart';

class QuranHomeCubit extends Cubit<QuranHomeState> {
  final QuranRepository quranRepo;
  final UserQuranRepository userRepo;
  final String? userId;

  QuranHomeCubit({
    required this.quranRepo,
    required this.userRepo,
    required this.userId,
  }) : super(QuranHomeState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final surahs = await quranRepo.getSurahs();
      final juz = await quranRepo.getJuzList();

      List<Bookmark> bookmarks = [];
      if (userId != null) {
        try {
          bookmarks = await userRepo.getBookmarks(userId!);
        } catch (e) {
          debugPrint('Failed to load bookmarks: $e');
        }
      }

      emit(
        state.copyWith(
          surahs: surahs,
          juz: juz,
          bookmarks: bookmarks,
          isLoading: false,
        ),
      );
    } catch (e) {
      // emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void changeTab(int index) {
    emit(state.copyWith(currentTab: index));
  }

  Future<void> refreshBookmarks() async {
    if (userId == null) return;

    try {
      final bookmarks = await userRepo.getBookmarks(userId!);
      emit(state.copyWith(bookmarks: bookmarks));
    } catch (e) {
      debugPrint('Failed to refresh bookmarks: $e');
    }
  }

  void toggleSearch() {
    emit(
      state.copyWith(
        isSearchActive: !state.isSearchActive,
        searchQuery: '',
        searchResults: [],
      ),
    );
  }

  void updateSearchQuery(String query) {
    final results = _filterSurahs(query, state.surahs);
    emit(state.copyWith(searchQuery: query, searchResults: results));
  }

  List<Chapter> _filterSurahs(String query, List<Chapter> allSurahs) {
    if (query.isEmpty) return [];

    return allSurahs.where((surah) {
      return surah.nameSimple.toLowerCase().contains(query.toLowerCase()) ||
          surah.nameArabic.contains(query) ||
          surah.id.toString().contains(query);
    }).toList();
  }

  void clearSearch() {
    emit(
      state.copyWith(isSearchActive: false, searchQuery: '', searchResults: []),
    );
  }
}
