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
      debugPrint('Response Staus : ${response.statusCode}');
      debugPrint('Response body : ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['juzs'] ?? [];

        // Parse and filter duplicates by juz_number
        final Map<int, JuzElement> uniqueJuzs = {};
        for (var json in data) {
          try {
            final juzElement = JuzElement.fromJson(json);
            // Keep only the first occurrence of each juz_number (filter duplicates)
            if (!uniqueJuzs.containsKey(juzElement.juzNumber)) {
              uniqueJuzs[juzElement.juzNumber] = juzElement;
            }
          } catch (e) {
            debugPrint('Error parsing Juz element: $e');
            // Skip invalid entries but continue processing
            continue;
          }
        }

        // Convert map to list and sort by juz_number
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
      // debugPrint('Response Staus : ${response.statusCode}');
      // debugPrint('Response body : ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['chapters'] ?? [];
        return data.map((json) => Chapter.fromJson(json)).toList();
      } else {
        throw Exception('Faileed to load todos ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Check emulator settings.');
    } catch (e) {
      debugPrint('Error : $e');
      throw Exception('Failed to loead todos: $e');
    }
  }

  @override
  Future<List<Ayah>> getVerses(int chapterId) async {
    try {
      // debugPrint('🔥 FETCHING VERSES FOR CHAPTER: $chapterId');
      final response = await http.get(
        Uri.parse(
          'https://api.quran.com/api/v4/verses/by_chapter/$chapterId'
          '?language=en' // Quran text language
          '&words=118' // Arabic words (Uthmani script)
          '&translations=131' // English Sahih International
          '&per_page=500' // All verses
          '&fields=text_uthmani,translations',
        ),
      ); // Adjust API as needed
      // debugPrint(
      //   '🔥 VERSES Response Status: ${response.statusCode}',
      // ); // ADD THIS
      // debugPrint(
      //   '🔥 VERSES Response body: ${response.body.substring(0, 500)}...',
      // );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['verses'] ?? [];
        // 🔥 ADD THIS DEBUG PRINT
        // if (data.isNotEmpty) {
        //   debugPrint('FIRST VERSE JSON: ${jsonEncode(data[0])}');
        //   debugPrint('Available keys: ${data[0].keys.toList()}');
        // }

        // debugPrint('🔥 TOTAL VERSES FOUND: ${data.length}');
        // if (data.isNotEmpty) {
        //   debugPrint('🔥 FIRST VERSE JSON: ${jsonEncode(data[0])}');
        // }
        return data.map((json) => Ayah.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load verses ${response.statusCode}');
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
      final response = await http.get(
        Uri.parse(
          'https://api.quran.com/api/v4/verses/by_juz/$juzNumber'
          '?language=en'
          '&words=118'
          '&translations=131'
          '&per_page=500'
          '&fields=text_uthmani,translations,chapter_id,verse_number',
        ),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['verses'] ?? [];
        return data.map((json) => Ayah.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Juz verses: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading Juz verses: $e');
      throw Exception('Failed to load Juz verses: $e');
    }
  }
}
