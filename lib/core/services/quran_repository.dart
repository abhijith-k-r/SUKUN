import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:sukun/features/quran/models/reading_progress_model.dart';
import 'package:sukun/features/quran/models/surah_model.dart';

abstract class QuranRepository {
  Future<List<Surah>> getSurahs();
  Future<List<Juz>> getJuzList();
}

abstract class UserQuranRepository {
  Future<ReadingProgress?> getLastReading(String userId);
  Future<List<Bookmark>> getBookmarks(String userId);
  Future<void> saveProgress(String userId, ReadingProgress progress);
  Future<void> addBookmark(String userId, Bookmark bookmark);
}
