import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:http/http.dart' as http;
import 'package:sukun/features/quran/models/surahs_model.dart';

class QuranRepositoryImplement implements QuranRepository {
  final surahsBaseUrl = 'https://api.quran.com/api/v4/chapters';
  final juzBaseUrl = 'https://api.quran.com/api/v4/juzs';

  @override
  Future<List<JuzElement>> getJuzList() async {
    try {
      final response = await http.get(Uri.parse(juzBaseUrl));
      debugPrint('Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['juzs'] ?? [];

        final Map<int, JuzElement> uniqueJuzs = {};
        for (var json in data) {
          try {
            final juzElement = JuzElement.fromJson(json);
            if (!uniqueJuzs.containsKey(juzElement.juzNumber)) {
              uniqueJuzs[juzElement.juzNumber] = juzElement;
            }
          } catch (e) {
            debugPrint('Error parsing Juz element: $e');
            continue;
          }
        }

        final List<JuzElement> juzList = uniqueJuzs.values.toList()
          ..sort((a, b) => a.juzNumber.compareTo(b.juzNumber));

        debugPrint('Loaded ${juzList.length} unique Juz elements');
        return juzList;
      } else {
        throw Exception('Failed to load Juz list: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Check emulator settings.');
    } catch (e) {
      debugPrint('Error loading Juz list: $e');
      throw Exception('Failed to load Juz list: $e');
    }
  }

  @override
  Future<List<Chapter>> getSurahs() async {
    try {
      final response = await http.get(Uri.parse(surahsBaseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['chapters'] ?? [];
        return data.map((json) => Chapter.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load surahs: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Check emulator settings.');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load surahs: $e');
    }
  }

  @override
  Future<List<Ayah>> getVerses(int chapterId) async {
    try {
      debugPrint('🔥 FETCHING VERSES FOR CHAPTER: $chapterId');
      final response = await http.get(
        Uri.parse(
          'https://api.quran.com/api/v4/verses/by_chapter/$chapterId'
          '?language=en'
          '&words=true' // Include word-by-word data
          '&translations=131' // Sahih International
          '&per_page=500'
          '&fields=text_uthmani,translations,verse_key,page_number',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['verses'] ?? [];

        debugPrint('🔥 TOTAL VERSES FOUND: ${data.length}');

        return data.map((json) => Ayah.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load verses: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection.');
    } catch (e) {
      debugPrint('🔥 VERSES ERROR: $e');
      throw Exception('Failed to load verses: $e');
    }
  }

  @override
  Future<List<Ayah>> getVersesByJuz(int juzNumber) async {
    try {
      debugPrint('🔥 FETCHING VERSES FOR JUZ: $juzNumber');
      final response = await http.get(
        Uri.parse(
          'https://api.quran.com/api/v4/verses/by_juz/$juzNumber'
          '?language=en'
          '&words=true'
          '&translations=131'
          '&per_page=500'
          '&fields=text_uthmani,translations,verse_key,chapter_id,page_number',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['verses'] ?? [];

        debugPrint('🔥 TOTAL VERSES FOR JUZ $juzNumber: ${data.length}');

        return data.map((json) => Ayah.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Juz verses: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading Juz verses: $e');
      throw Exception('Failed to load Juz verses: $e');
    }
  }

  // ✅ NEW: Fetch verses by page number (1-604)
  @override
  Future<List<Ayah>> getVersesByPage(int pageNumber) async {
    try {
      debugPrint('🔥 FETCHING VERSES FOR PAGE: $pageNumber');
      final response = await http.get(
        Uri.parse(
          'https://api.quran.com/api/v4/verses/by_page/$pageNumber'
          '?language=en'
          '&words=true'
          '&translations=131'
          '&per_page=500'
          '&fields=text_uthmani,translations,verse_key,chapter_id,page_number',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['verses'] ?? [];

        debugPrint('🔥 TOTAL VERSES FOR PAGE $pageNumber: ${data.length}');

        return data.map((json) => Ayah.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load page verses: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading page verses: $e');
      throw Exception('Failed to load page verses: $e');
    }
  }
}
