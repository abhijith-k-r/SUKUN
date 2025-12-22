import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:sukun/features/quran/models/reading_progress_model.dart';

import 'package:sukun/features/quran/models/surah_model.dart';

import 'quran_repository.dart'; 



class QuranRepositoryImpl implements QuranRepository {
  @override
  Future<List<Surah>> getSurahs() async {
    final response = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/surah'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final surahs = data['data'] as List;
      return surahs.map((s) => Surah.fromJson(s)).toList();
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  @override
  Future<List<Juz>> getJuzList() async {
    // For simplicity, return a list of juz numbers, but you can fetch actual data
    return List.generate(
      30,
      (index) => Juz(
        number: index + 1,
        name: 'Juz ${index + 1}',
        start: 'Surah X',
        end: 'Surah Y',
      ),
    );
  }
}

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
