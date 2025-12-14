import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sukun/features/auth/model/auth_request_model.dart';
import 'package:sukun/features/auth/model/usre_model.dart';

class AuthServices {
  final baseUrl =
      "https://kfvlwl8h-3000.inc1.devtunnels.ms/register";

  Future<UsreModel> register(AuthRequestModel request) async {
    debugPrint('Creating todo: ${request.toJson()}');

    try {
      final response = await http.post(
        Uri.parse('https://kfvlwl8h-3000.inc1.devtunnels.ms/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      debugPrint('Create response status: ${response.statusCode}');
      debugPrint('Create response body: ${response.body}');

      if (response.statusCode == 200 && response.statusCode == 201) {
        return UsreModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
