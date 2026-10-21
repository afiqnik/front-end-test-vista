import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/company.dart';

class ApiService {
  // Flutter web running on the same laptop as the backend.
  static const String baseUrl = 'http://localhost:3000';

  Future<List<Company>> getCompanies() async {
    final response = await http.get(Uri.parse('$baseUrl/companies'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => Company.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load companies');
  }

  Future<void> createCompany({
    required String name,
    required String registrationNumber,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/companies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'registrationNumber': registrationNumber,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(_getErrorMessage(response, 'Failed to create company'));
    }
  }

  Future<void> createService({
    required int companyId,
    required String name,
    required String description,
    required double price,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/services'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'companyId': companyId,
        'name': name,
        'description': description,
        'price': price,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(_getErrorMessage(response, 'Failed to create service'));
    }
  }

  String _getErrorMessage(http.Response response, String fallback) {
    try {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic> && data['message'] is String) {
        return data['message'] as String;
      }
    } catch (_) {
      // Use the fallback when the response is not valid JSON.
    }

    return '$fallback (${response.statusCode})';
  }
}
