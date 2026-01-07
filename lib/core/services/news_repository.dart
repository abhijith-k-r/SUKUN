import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:sukun/features/news/model/news_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  final baseUrl = 'https://sukunweb.com/api/admin/news';

  Future<List<Datum>> getNews() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      debugPrint('Response Staus : ${response.statusCode}');
      debugPrint('Response body : ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final sukunNews = SukunNews.fromJson(responseData); 
        return sukunNews.data;
      } else {
        throw Exception('Faileed to load News:  ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error : $e');
      throw Exception('Failed to lead News: $e');
    }
  }
}
