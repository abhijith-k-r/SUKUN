import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/reading_progress_model.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_state.dart';

class QuranHomeCubit extends Cubit<QuranHomeState> {
  final QuranRepository quranRepo;
  final UserQuranRepository userRepo;
  final String? userId; // null => guest

  QuranHomeCubit({
    required this.quranRepo,
    required this.userRepo,
    required this.userId,
  }) : super(QuranHomeState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(loading: true));
    final surahs = await quranRepo.getSurahs();
    final juz = await quranRepo.getJuzList();
    ReadingProgress? last;
    List<Bookmark> bookmarks = [];

    if (userId != null) {
      last = await userRepo.getLastReading(userId!);
      bookmarks = await userRepo.getBookmarks(userId!);
    }

    emit(
      state.copyWith(
        loading: false,
        surahs: surahs,
        juz: juz,
        lastReading: last,
        bookmarks: bookmarks,
      ),
    );
  }

  void changeTab(int index) {
    emit(state.copyWith(currentTabIndex: index));
  }
}
