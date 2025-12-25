import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/quran/view_models/cubit/surah_detail_state.dart';

class SurahDetailCubit extends Cubit<SurahDetailState> {
  final QuranRepository quranRepo;

  SurahDetailCubit({required this.quranRepo}) : super(SurahDetailInitial());

  Future<void> loadSurahDetail(int surahNumber) async {
    emit(SurahDetailLoading());
    try {
      // In a real optimized app, you might pass the basic Surah object 
      // instead of fetching all again, but for now we follow the existing pattern
      // or we can just fetch surahs if needed. 
      // Actually, to get the Surah metadata + Verses:
      
      final surahs = await quranRepo.getSurahs();
      final surah = surahs.firstWhere((s) => s.id == surahNumber);
      
      // Fetch verses
      final verses = await quranRepo.getVerses(surahNumber);
      
      // Combine
      final surahWithVerses = surah.copyWith(verses: verses);
      
      emit(SurahDetailLoaded(surahWithVerses));
    } catch (e) {
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
