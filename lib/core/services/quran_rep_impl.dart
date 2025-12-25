import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:http/http.dart' as http;
import 'package:sukun/features/quran/models/surahs_model.dart';

class QuranRepositoryImplement implements QuranRepository {
  final baseUrl = 'https://api.quran.com/api/v4/chapters';

  @override
  Future<List<Juz>> getJuzList() async {
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

  @override
  Future<List<Chapter>> getSurahs() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      debugPrint('Response Staus : ${response.statusCode}');
      debugPrint('Response body : ${response.body}');

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
      final response = await http.get(
        Uri.parse(
          'https://api.quran.com/api/v4/verses/by_chapter/$chapterId?language=en&translations=131',
        ),
      ); // Adjust API as needed
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['verses'] ?? [];
        return data.map((json) => Ayah.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load verses ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection.');
    } catch (e) {
      throw Exception('Failed to load verses: $e');
    }
  }
}
