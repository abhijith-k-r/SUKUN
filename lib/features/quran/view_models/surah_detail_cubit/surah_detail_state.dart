import 'package:sukun/features/quran/models/surahs_model.dart';

abstract class SurahDetailState {}

class SurahDetailInitial extends SurahDetailState {}

class SurahDetailLoading extends SurahDetailState {}

class SurahDetailLoaded extends SurahDetailState {
  final Chapter surah;
  SurahDetailLoaded(this.surah);
}

class SurahDetailError extends SurahDetailState {
  final String message;
  SurahDetailError(this.message);
}
