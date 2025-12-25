import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/reading_progress_model.dart';

import 'quran_repository.dart';


class UserQuranRepositoryImpl implements UserQuranRepository {
  @override
  Future<ReadingProgress?> getLastReading(String userId) async {
    // Implement logic
    throw UnimplementedError('getLastReading not implemented');
  }

  @override
  Future<List<Bookmark>> getBookmarks(String userId) async {
    // Implement logic
    throw UnimplementedError('getBookmarks not implemented');
  }

  @override
  Future<void> saveProgress(String userId, ReadingProgress progress) async {
    // Implement logic
    throw UnimplementedError('saveProgress not implemented');
  }

  @override
  Future<void> addBookmark(String userId, Bookmark bookmark) async {
    // Implement logic
    throw UnimplementedError('addBookmark not implemented');
  }
}
