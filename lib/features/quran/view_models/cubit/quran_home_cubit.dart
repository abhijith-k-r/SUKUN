import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/reading_progress_model.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_state.dart';

class QuranHomeCubit extends Cubit<QuranHomeState> {
  final QuranRepository quranRepo;
  final UserQuranRepository userRepo;
  final String? userId;

  QuranHomeCubit({
    required this.quranRepo,
    required this.userRepo,
    required this.userId,
  }) : super(QuranHomeInitial()) {
    init();
  }

  Future<void> init() async {
    // Preserve existing data and tab index when re-initializing
    final currentTabIndex = state.currentTabIndex;
    final existingSurahs = state.surahs;
    final existingJuz = state.juz;
    final existingBookmarks = state.bookmarks;
    final existingLastReading = state.lastReading;
    
    emit(QuranHomeInitial().copyWith(
      currentTabIndex: currentTabIndex,
      surahs: existingSurahs,
      juz: existingJuz,
      bookmarks: existingBookmarks,
      lastReading: existingLastReading,
    ));
    
    try {
      final surahs = await quranRepo.getSurahs();
      final juz = await quranRepo.getJuzList();
      ReadingProgress? last = existingLastReading;
      List<Bookmark> bookmarks = existingBookmarks;

      try {
        if (userId != null) {
          last = await userRepo.getLastReading(userId!) ?? existingLastReading;
          bookmarks = await userRepo.getBookmarks(userId!);
        }
      } catch (e) {
        debugPrint('User data error (OK for guest): $e');
        // Continue with existing data
      }
      
      final loadedState = QuranHomeLoaded(
        surahs: surahs.isNotEmpty ? surahs : existingSurahs,
        juz: juz.isNotEmpty ? juz : existingJuz,
        lastReading: last,
        bookmarks: bookmarks.isNotEmpty ? bookmarks : existingBookmarks,
      );
      
      // Always preserve current tab index
      emit(loadedState.copyWith(currentTabIndex: currentTabIndex));
    } catch (e) {
      debugPrint('QuranHomeCubit ERROR: $e');
      // On error, preserve existing data
      emit(state.copyWith(
        errors: e.toString(),
        isLoading: false,
        currentTabIndex: currentTabIndex,
      ));
    }
  }

  void changeTab(int index) {
    // Always preserve all data when switching tabs
    if (state is QuranHomeLoaded) {
      final loadedState = state as QuranHomeLoaded;
      emit(loadedState.copyWith(currentTabIndex: index));
    } else {
      // Even if not fully loaded, preserve existing data and just change tab
      emit(state.copyWith(currentTabIndex: index));
    }
  }
}
