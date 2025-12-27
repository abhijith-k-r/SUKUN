import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:sukun/features/quran/models/reading_progress_model.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';

abstract class QuranRepository {
  Future<List<Chapter>> getSurahs();
  Future<List<JuzElement>> getJuzList();
  Future<List<Ayah>> getVerses(int chapterId);
  Future<List<Ayah>> getVersesByJuz(int juzNumber);
}

abstract class UserQuranRepository {
  Future<ReadingProgress?> getLastReading(String userId);
  Future<List<Bookmark>> getBookmarks(String userId);
  Future<void> saveProgress(String userId, ReadingProgress progress);
  Future<void> addBookmark(String userId, Bookmark bookmark);
}
