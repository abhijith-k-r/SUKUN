import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/quran/view_models/cubit/surah_detail_state.dart';

class SurahDetailCubit extends Cubit<SurahDetailState> {
  final QuranRepository quranRepo;

  SurahDetailCubit({required this.quranRepo}) : super(SurahDetailInitial());

  Future<void> loadSurahDetail(int surahNumber) async {
    emit(SurahDetailLoading());
    try {
      debugPrint('🔥 SurahDetailCubit: Loading surah $surahNumber');

      final surahs = await quranRepo.getSurahs();
      final surah = surahs.firstWhere((s) => s.id == surahNumber);

      // Fetch verses
      final verses = await quranRepo.getVerses(surahNumber);
debugPrint('🔥 SurahDetailCubit: Got ${verses.length} verses');
      // Combine
      final surahWithVerses = surah.copyWith(verses: verses);

      emit(SurahDetailLoaded(surahWithVerses));
    } catch (e) {
      debugPrint('🔥 SurahDetailCubit ERROR: $e'); 
      emit(SurahDetailError(e.toString()));
    }
  }

  void navigateToNextSurah(int currentSurahId) {
    if (currentSurahId < 114) {
      loadSurahDetail(currentSurahId + 1);
    }
  }

  void navigateToPreviousSurah(int currentSurahId) {
    if (currentSurahId > 1) {
      loadSurahDetail(currentSurahId - 1);
    }
  }
}
